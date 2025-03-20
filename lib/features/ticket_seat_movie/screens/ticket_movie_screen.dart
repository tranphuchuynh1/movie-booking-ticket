import 'package:flutter/material.dart';

class TicketMovieScreen extends StatelessWidget {
  const TicketMovieScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Container(
          width: 350,
          height: 600,
          decoration: BoxDecoration(
            color: Color(0xFF161616),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              // Close Button
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: Icon(Icons.close, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              // Movie Image
              Container(
                height: 300,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/conan-movie.jpg'),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
              ),
              // Movie Info
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Movie 23',
                      style: TextStyle(
                        color: Colors.orange,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'CHAPTER 4',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    SizedBox(height: 20),
                    // Date and Time
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '18',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                              ),
                            ),
                            Text(
                              'Mon',
                              style: TextStyle(color: Colors.white70),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hall: 02',
                              style: TextStyle(color: Colors.white),
                            ),
                            Text(
                              'Row: 04',
                              style: TextStyle(color: Colors.white),
                            ),
                            Text(
                              'Seats: 23,24',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      height: 50,
                      color: Colors.orange,
                      margin: EdgeInsets.symmetric(vertical: 20),
                      child: Center(
                        child: Text(
                          'Barcode Here',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
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
          radius: 30, // Set radius for circular avatar
          child: IconButton(
            onPressed: () {},
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

        CircleAvatar(
          backgroundColor: Colors.black,
          radius: 30,
          child: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.confirmation_number, color: Colors.white),
            iconSize: 30,
          ),
        ),

        CircleAvatar(
          backgroundColor: Colors.black,
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
