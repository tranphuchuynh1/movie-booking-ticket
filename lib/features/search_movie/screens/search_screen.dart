import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_booking_ticket/core/models/movie_model.dart';
import 'package:movie_booking_ticket/features/search_movie/bloc/search_bloc.dart';
import 'package:movie_booking_ticket/features/search_movie/bloc/search_event.dart';
import 'package:movie_booking_ticket/features/search_movie/bloc/search_state.dart';
import 'package:movie_booking_ticket/features/search_movie/screens/search_skeleton.dart';
import '../../../core/widgets/bottom_nav_bar.dart';
import 'package:flutter_debouncer/flutter_debouncer.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final Debouncer _debouncer = Debouncer();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (GoRouterState.of(context).extra != null &&
          (GoRouterState.of(context).extra as Map)['autoFocus'] == true) {
        _searchFocusNode.requestFocus();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debouncer.cancel();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SearchBloc>(
      create: (context) => SearchBloc()..add(SearchMovieEvent('')),
      child: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: Colors.black,
            body: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Search Bar
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: TextField(
                        controller: _searchController,
                        focusNode: _searchFocusNode,
                        onChanged: (query) {
                          _debouncer.debounce(
                            duration: Duration(milliseconds: 500),
                            onDebounce: () {
                              context.read<SearchBloc>().add(
                                SearchMovieEvent(query),
                              );
                            },
                          );
                        },
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Search your Movies...',
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 16),
                          suffixIcon: Icon(Icons.search, color: Colors.red),
                        ),
                      ),
                    ),
                  ),

                  // Movie List
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 10,
                    ),
                    child: Text(
                      'Kết Quả Tìm Kiếm',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  Expanded(
                    child: BlocBuilder<SearchBloc, SearchMovieState>(
                      builder: (context, state) {
                        if (state.status == SearchMovieStateStatus.loading) {
                          return ListView.separated(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: 5, // Number of placeholder items
                            separatorBuilder:
                                (context, index) => const SizedBox(height: 16),
                            itemBuilder:
                                (context, index) =>
                            const SearchResultPlaceholder(),
                          );
                        } else if (state.status ==
                            SearchMovieStateStatus.error) {
                          return Center(
                            child: Text(
                              state.errorMessage ?? 'Error occurred',
                              style: const TextStyle(color: Colors.white),
                            ),
                          );
                        } else if (state.searchResults.isEmpty &&
                            _searchController.text.trim().isNotEmpty) {
                          return const Center(
                            child: Text(
                              'No results found',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          );
                        } else {
                          return ListView.builder(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            itemCount: state.searchResults.length,
                            itemBuilder: (context, index) {
                              final MovieModel movie =
                              state.searchResults[index];
                              return GestureDetector(
                                onTap: () {
                                  context.go('/search/detail/${movie.movieId}');
                                },
                                child: Container(
                                  margin: EdgeInsets.only(bottom: 16),
                                  child: Row(
                                    children: [
                                      // Movie Poster
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child:
                                        movie.imageMovie != null &&
                                            movie.imageMovie!.isNotEmpty
                                            ? Image.network(
                                          movie.imageMovie!.first,
                                          width: 100,
                                          height: 150,
                                          fit: BoxFit.cover,
                                        )
                                            : Container(
                                          width: 100,
                                          height: 150,
                                          color: Colors.grey,
                                          child: Icon(
                                            Icons.movie,
                                            color: Colors.white,
                                            size: 40,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 16),

                                      // Movie Details
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              movie.title ?? 'No Title',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            SizedBox(height: 8),
                                            Text(
                                              movie.genres != null
                                                  ? movie.genres!.join(', ')
                                                  : 'No Genres',
                                              style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 14,
                                              ),
                                            ),
                                            SizedBox(height: 8),
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.star,
                                                  color: Colors.amber,
                                                  size: 18,
                                                ),
                                                SizedBox(width: 4),
                                                Text(
                                                  '${movie.rating}/10',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            bottomNavigationBar: const BottomNavBar(selectedIndex: 1),
          );
        },
      ),
    );
  }
}