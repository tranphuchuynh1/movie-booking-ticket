import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentNowPlayingIndex = 0;

  @override
  Widget build(BuildContext context) {
    // fake movie data
    final List<Map<String, dynamic>> nowPlayingMovies = [
      {
        'title': 'John Wick: Chapter 4',
        'image': 'assets/images/phim.jpeg',
        'rating': '8.0 (1,024)',
        'genres': ['Action', 'Thriller', 'Crime'],
      },
      {
        'title': 'Shazam',
        'image': 'assets/images/phim.jpeg',
        'rating': '7.5 (950)',
        'genres': ['Action', 'Adventure', 'Comedy'],
      },
      {
        'title': 'Movie 3',
        'image': 'assets/images/phim.jpeg',
        'rating': '7.8 (820)',
        'genres': ['Drama', 'Action'],
      },
      {
        'title': 'Movie 4',
        'image': 'assets/images/phim.jpeg',
        'rating': '8.2 (1,150)',
        'genres': ['Horror', 'Thriller'],
      },
    ];

    final List<Map<String, dynamic>> popularMovies = [
      {
        'title': 'Shazam',
        'image': 'assets/images/phim.jpeg',
      },
      {
        'title': 'John Wick: Chapter 4',
        'image': 'assets/images/phim.jpeg',
      },
      {
        'title': 'Movie 3',
        'image': 'assets/images/phim.jpeg',
      },
      {
        'title': 'Movie 4',
        'image': 'assets/images/phim.jpeg',
      },
    ];

    final List<Map<String, dynamic>> upcomingMovies = [
      {
        'title': 'Shazam',
        'image': 'assets/images/phim.jpeg',
      },
      {
        'title': 'John Wick: Chapter 4',
        'image': 'assets/images/phim.jpeg',
      },
      {
        'title': 'Movie 3',
        'image': 'assets/images/phim.jpeg',
      },
      {
        'title': 'Movie 4',
        'image': 'assets/images/phim.jpeg',
      },
    ];

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              // Search bar
              Padding(
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
              ),
              const SizedBox(height: 24),

              // Now Playing Section
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
                height: 580, // increase limit height for sizedbox
                child: Column(
                  children: [
                    CarouselSlider.builder(
                      itemCount: nowPlayingMovies.length,
                      options: CarouselOptions(
                        height: 450, // Increased to 450px as requested
                        enlargeCenterPage: true,
                        viewportFraction: 0.75,
                        onPageChanged: (index, reason) {
                          setState(() {
                            _currentNowPlayingIndex = index;
                          });
                        },
                      ),
                      itemBuilder: (context, index, realIndex) {
                        return _buildNowPlayingMovieCard(
                          nowPlayingMovies[index]['image'],
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    // Show rating for current movie
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 18),
                        const SizedBox(width: 4),
                        Text(
                          nowPlayingMovies[_currentNowPlayingIndex]['rating'],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Show title for current movie
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        nowPlayingMovies[_currentNowPlayingIndex]['title'],
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
                    // Show genres for current movie
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          for (var genre in nowPlayingMovies[_currentNowPlayingIndex]['genres'])
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4.0),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: Colors.grey.shade800),
                                ),
                                child: Text(
                                  genre,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // Popular Section
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Popular',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Horizontal list for Popular movies
              SizedBox(
                height: 180,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: popularMovies.length,

                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: _buildMoviePoster(
                        popularMovies[index]['title'],
                        popularMovies[index]['image'],
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 24),

              // Upcoming Section
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Upcoming',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Horizontal list for Upcoming movies
              SizedBox(
                height: 180,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: upcomingMovies.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: _buildMoviePoster(
                        upcomingMovies[index]['title'],
                        upcomingMovies[index]['image'],
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildNowPlayingMovieCard(String imagePath) {
    return GestureDetector(
      onTap: () {
        context.go('/detail');
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _buildMoviePoster(String title, String imagePath) {
    return GestureDetector(
      onTap: () {
        context.go('/detail');
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              imagePath,
              height: 150,
              width: 100,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: 100,
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildBottomNavigationBar() {
    return Container(
      height: 75,
      margin: EdgeInsets.fromLTRB(5, 0, 5, 5),
      color: Colors.black,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // First Icon - Home
          CircleAvatar(
            backgroundColor: Colors.deepOrange, // Background color
            radius: 30,  // Set radius for circular avatar
            child: IconButton(
              onPressed: () {
                context.go('/');
              },
              icon: const Icon(Icons.home, color: Colors.white),
              iconSize: 30, // Adjust icon size
            ),
          ),

          // Second Icon - Search
          CircleAvatar(
            backgroundColor: Colors.black, // Set background color to black
            radius: 30,
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.search, color: Colors.white),
              iconSize: 30,
            ),
          ),

          // Third Icon - Ticket
          CircleAvatar(
            backgroundColor: Colors.black, // Set background color to black
            radius: 30,
            child: IconButton(
              onPressed: () {
                context.go('/ticket');
              },
              icon: const Icon(Icons.confirmation_number, color: Colors.white),
              iconSize: 30,
            ),
          ),

          // Fourth Icon - Profile
          CircleAvatar(
            backgroundColor: Colors.black, // Set background color to black
            radius: 30,
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.account_circle, color: Colors.white),
              iconSize: 30,
            ),
          ),
        ],
      ),
    );
  }
}