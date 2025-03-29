import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../core/models/movie_model.dart';
import '../../../core/widgets/bottom_nav_bar.dart';
import '../bloc/movie_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentNowPlayingIndex = 0;

  @override
  void initState() {
    super.initState();
    context.read<MovieBloc>().add(FetchMoviesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocBuilder<MovieBloc, MovieState>(
        builder: (context, state) {
          if (state.status == MovieStatus.loading) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.red),
            );
          }

          if (state.status == MovieStatus.error) {
            return Center(
              child: Text(
                'Error: ${state.errorMessage}',
                style: const TextStyle(color: Colors.white),
              ),
            );
          }

          return _buildHomeContent(state);
        },
      ),
      bottomNavigationBar: const BottomNavBar(selectedIndex: 0),
    );
  }

  Widget _buildHomeContent(MovieState state) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            _buildSearchBar(),
            const SizedBox(height: 24),
            if (state.nowPlayingMovies.isNotEmpty)
              _buildNowPlayingSection(state.nowPlayingMovies),
            const SizedBox(height: 10),
            if (state.popularMovies.isNotEmpty)
              _buildMovieSection('Popular', state.popularMovies),
            const SizedBox(height: 24),
            if (state.upcomingMovies.isNotEmpty)
              _buildMovieSection('Upcoming', state.upcomingMovies),
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            const Expanded(
              child: Text(
                'Search your Movies...',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.search, color: Colors.red),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNowPlayingSection(List<MovieModel> nowPlayingMovies) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Now Playing',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 580,
          child: Column(
            children: [
              CarouselSlider.builder(
                itemCount: nowPlayingMovies.length,
                options: CarouselOptions(
                  height: 450,
                  enlargeCenterPage: true,
                  viewportFraction: 0.75,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _currentNowPlayingIndex = index;
                    });
                  },
                ),
                itemBuilder: (context, index, realIndex) {
                  return _buildNowPlayingMovieCard(nowPlayingMovies[index]);
                },
              ),
              const SizedBox(height: 10),
              _buildMovieDetails(nowPlayingMovies[_currentNowPlayingIndex]),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMovieDetails(MovieModel movie) {
    return Column(
      children: [
        // Rating
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.star, color: Colors.amber, size: 18),
            const SizedBox(width: 4),
            Text(
              '${movie.rating ?? 0}',
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // Title
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            movie.title ?? 'No Title',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(height: 12),
        // Genres
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: (movie.genres ?? []).map((genre) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey.shade800),
                  ),
                  child: Text(
                    genre,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildMovieSection(String title, List<MovieModel> movies) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: movies.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: _buildMoviePoster(movies[index]),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildNowPlayingMovieCard(MovieModel movie) {
    return GestureDetector(
      onTap: () {
        context.go('/detail', extra: movie);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          image: DecorationImage(
            image: NetworkImage(movie.imageMovie?.first ?? ''),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _buildMoviePoster(MovieModel movie) {
    return GestureDetector(
      onTap: () {
        context.go('/detail', extra: movie);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: CachedNetworkImage(
              imageUrl: movie.imageMovie?.first ?? '',
              height: 150,
              width: 100,
              fit: BoxFit.cover,
              placeholder: (context, url) =>
              const Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) =>
              const Icon(Icons.movie, size: 100),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: 100,
            child: Text(
              movie.title ?? 'No Title',
              style: const TextStyle(color: Colors.white, fontSize: 12),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}