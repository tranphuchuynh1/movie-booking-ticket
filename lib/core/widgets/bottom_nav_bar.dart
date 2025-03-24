import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;

  const BottomNavBar({
    super.key,
    required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 75,
      margin: EdgeInsets.fromLTRB(5, 0, 5, 5),
      color: Colors.black,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Home Icon
          CircleAvatar(
            backgroundColor: selectedIndex == 0 ? Colors.deepOrange : Colors.black,
            radius: 30,
            child: IconButton(
              onPressed: () {
                if (selectedIndex != 0) {
                  context.go('/home');
                }
              },
              icon: const Icon(Icons.home, color: Colors.white),
              iconSize: 30,
            ),
          ),

          // Search Icon
          CircleAvatar(
            backgroundColor: selectedIndex == 1 ? Colors.deepOrange : Colors.black,
            radius: 30,
            child: IconButton(
              onPressed: () {
                if (selectedIndex != 1) {
                  // context.go('/search');
                }
              },
              icon: const Icon(Icons.search, color: Colors.white),
              iconSize: 30,
            ),
          ),

          // Ticket Icon
          CircleAvatar(
            backgroundColor: selectedIndex == 2 ? Colors.deepOrange : Colors.black,
            radius: 30,
            child: IconButton(
              onPressed: () {
                if (selectedIndex != 2) {
                  context.go('/ticket');
                }
              },
              icon: const Icon(Icons.confirmation_number, color: Colors.white),
              iconSize: 30,
            ),
          ),

          // Profile Icon
          CircleAvatar(
            backgroundColor: selectedIndex == 3 ? Colors.deepOrange : Colors.black,
            radius: 30,
            child: IconButton(
              onPressed: () {
                if (selectedIndex != 3) {
                  context.go('/profile');
                }
              },
              icon: const Icon(Icons.account_circle, color: Colors.white),
              iconSize: 30,
            ),
          ),
        ],
      ),
    );
  }
}