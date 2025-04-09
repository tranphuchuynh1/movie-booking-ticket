import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_booking_ticket/core/models/movie_model.dart';
import 'package:movie_booking_ticket/features/search_movie/bloc/search_bloc.dart';
import 'package:movie_booking_ticket/features/search_movie/bloc/search_event.dart';
import 'package:movie_booking_ticket/features/search_movie/bloc/search_state.dart';
import '../../../core/widgets/bottom_nav_bar.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // List<Movie> _allMovies = [];
  // List<Movie> _filteredMovies = [];

  // @override
  // void initState() {
  //   super.initState();

  //   final castData = CastData();
  //   final moviesData = MoviesData(castData);
  //   _allMovies = moviesData.getAllMovies();
  //   _filteredMovies = _allMovies;
  // }

  // void _filterMovies(String query) {
  //   setState(() {
  //     _filteredMovies =
  //         _allMovies
  //             .where(
  //               (movie) =>
  //                   movie.title.toLowerCase().contains(query.toLowerCase()),
  //             )
  //             .toList();
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SearchBloc>(
      create: (_) => SearchBloc(),
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
                        onChanged: (query) {
                          context.read<SearchBloc>().add(
                            SearchMovieEvent(query),
                          );
                        },
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Search your Movies...',
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none,
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
                      'Search Results',
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
                          return const Center(
                            child: CircularProgressIndicator(color: Colors.red),
                          );
                        } else if (state.status ==
                            SearchMovieStateStatus.error) {
                          return Center(
                            child: Text(
                              state.errorMessage ?? 'Error occurred',
                              style: const TextStyle(color: Colors.white),
                            ),
                          );
                        } else if (state.searchResults.isEmpty) {
                          return const Center(
                            child: Text(
                              'No results found',
                              style: TextStyle(color: Colors.white),
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
                                  context.go('/detail', extra: movie);
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
