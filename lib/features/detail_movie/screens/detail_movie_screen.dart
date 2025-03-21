import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_booking_ticket/core/routes/app_routes.dart';

class MovieDetailScreen extends StatelessWidget {
  const MovieDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Fake data for detail
    final movie = {
      'title': 'John Wick: Chapter 4',
      'rating': 8.0,
      'voteCount': 1024,
      'releaseDate': '24 March 2023',
      'duration': '2h 50m',
      'genres': ['Action', 'Thriller', 'Crime'],
      'tagline': 'No way back, one way out.',
      'plot':
          'With the price on his head ever increasing, John Wick uncovers a path to defeating The High Table. But before he can earn his freedom, Wick must face off against a new enemy with powerful alliances across the globe and forces that turn old friends into foes.',
      'posterUrl': 'assets/images/phim.jpeg',
      'cast': [
        {
          'name': 'Keanu Reeves',
          'character': 'John Wick',
          'profileUrl': 'assets/images/tranthanh.jpg',
        },
        {
          'name': 'Donnie Yen',
          'character': 'Caine',
          'profileUrl': 'assets/images/tranthanh.jpg',
        },
        {
          'name': 'Bill Skarsgård',
          'character': 'Marquis',
          'profileUrl': 'assets/images/tranthanh.jpg',
        },
        {
          'name': 'Ian McShane',
          'character': 'Winston',
          'profileUrl': 'assets/images/tranthanh.jpg',
        },
        {
          'name': 'Laurence Fishburne',
          'character': 'Bowery King',
          'profileUrl': 'assets/images/tranthanh.jpg',
        },
      ],
    };

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildMoviePoster(context, movie),
              _buildMovieInfo(movie),
              _buildMovieDetails(movie),
              _buildCastSection(movie),
              const SizedBox(height: 20),
            ],
          ),
        ),
        bottomNavigationBar: _buildBottomButton(),
      ),
    );
  }

  Widget _buildMoviePoster(BuildContext context, Map<String, dynamic> movie) {
    return Stack(
      children: [
        // Background trailer image
        Container(
          height: 400,
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/phim.jpeg'),
              fit: BoxFit.cover,
            ),
          ),
        ),

        // Gradient overlay - darker at bottom half
        Container(
          height: 400,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.1), // Less dark at top
                Colors.black.withOpacity(0.9), // Very dark at bottom
              ],
              stops: const [0.1, 0.5], // Start darkening from middle (0.5)
            ),
          ),
        ),

        // Close button
        Positioned(
          top: 15,
          left: 10,
          child: Container(
            height: 30,
            decoration: const BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 15),
              onPressed: () {
                context.go('/home');
              },
            ),
          ),
        ),

        // Movie poster positioned at bottom
        Positioned(
          bottom: -25,
          left: 0,
          right: 0,
          child: Container(
            alignment: Alignment.center,
            child: Container(
              height: 320,
              width: 200,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(1),
                image: DecorationImage(
                  image: AssetImage('assets/images/phim.jpeg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMovieInfo(Map<String, dynamic> movie) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Duration in center
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.access_time, color: Colors.white54, size: 16),
                const SizedBox(width: 4),
                Text(
                  movie['duration'],
                  style: const TextStyle(color: Colors.white54),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Title
          Center(
            child: Text(
              movie['title'],
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          const SizedBox(height: 12),

          // Genre tags
          Center(
            child: Wrap(
              spacing: 8,
              children:
                  (movie['genres'] as List<String>).map((genre) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white24),
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.black,
                      ),
                      child: Text(
                        genre,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    );
                  }).toList(),
            ),
          ),

          const SizedBox(height: 12),

          // Tagline
          Center(
            child: Text(
              movie['tagline'],
              style: TextStyle(color: Colors.white.withOpacity(0.7)),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMovieDetails(Map<String, dynamic> movie) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Rating and date - left aligned
          Row(
            children: [
              const Icon(Icons.star, color: Colors.amber, size: 20),
              const SizedBox(width: 4),
              Text(
                '${movie['rating']} (${movie['voteCount']})',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 16),
              Text(
                movie['releaseDate'],
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Plot - left aligned
          Text(
            movie['plot'],
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildCastSection(Map<String, dynamic> movie) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Text(
            'Top Cast',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: movie['cast'].length,
            itemBuilder: (context, index) {
              final actor = movie['cast'][index];
              return Padding(
                padding: EdgeInsets.only(
                  left: index == 0 ? 16.0 : 8.0,
                  right: 8.0,
                ),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 35,
                      backgroundImage: AssetImage(actor['profileUrl']),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: 70,
                      child: Text(
                        actor['name'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBottomButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 100.0, vertical: 16.0),
      child: ElevatedButton(
        onPressed: () {
          appRouter.go('/select_seat');
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepOrange,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: const Text(
          'Select Seats',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
