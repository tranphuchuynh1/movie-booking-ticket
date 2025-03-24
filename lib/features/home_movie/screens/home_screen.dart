import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_booking_ticket/core/widgets/bottom_nav_bar.dart';
import '../../../core/data/fake_data.dart';
import '../../../core/models/movie.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentNowPlayingIndex = 0;

  final _data = FakeData();
  late List<Movie> _nowPlayingMovies;
  late List<Movie> _popularMovies;
  late List<Movie> _upcomingMovies;

  @override
  void initState() {
    super.initState();
    _nowPlayingMovies = _data.getNowPlayingMovies();
    _popularMovies = _data.getPopularMovies();
    _upcomingMovies = _data.getUpcomingMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              _buildSearchBar(),
              const SizedBox(height: 24),
              _buildNowPlayingSection(),
              const SizedBox(height: 10),
              _buildMovieSection('Popular', _popularMovies),
              const SizedBox(height: 24),
              _buildMovieSection('Upcoming', _upcomingMovies),
              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavBar(selectedIndex: 0),
    );
  }

  // Search Bar
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

  // Now Playing Section
  Widget _buildNowPlayingSection() {
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
                itemCount: _nowPlayingMovies.length,
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
                  return _buildNowPlayingMovieCard(_nowPlayingMovies[index]);
                },
              ),
              const SizedBox(height: 10),
              // Rating
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 18),
                  const SizedBox(width: 4),
                  Text(
                    '${_nowPlayingMovies[_currentNowPlayingIndex].rating}',
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  _nowPlayingMovies[_currentNowPlayingIndex].title,
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
                  children: _nowPlayingMovies[_currentNowPlayingIndex].genres.map((genre) {
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
          ),
        ),
      ],
    );
  }

  // Popular & Upcoming Movies Section
  Widget _buildMovieSection(String title, List<Movie> movies) {
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

  // Now Playing Movie Card
  Widget _buildNowPlayingMovieCard(Movie movie) {
    return GestureDetector(
      onTap: () {
        context.go('/detail', extra: movie);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          image: DecorationImage(
            image: AssetImage(movie.posterUrl),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  // Popular/Upcoming Movie Poster
  Widget _buildMoviePoster(Movie movie) {
    return GestureDetector(
      onTap: () {
        context.go('/detail', extra: movie);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              movie.posterUrl,
              height: 150,
              width: 100,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: 100,
            child: Text(
              movie.title,
              style: const TextStyle(color: Colors.white, fontSize: 12),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
