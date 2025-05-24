import 'package:flutter/material.dart';

class CustomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  static const Color mainBlue = Color(0xFF3964C3);

  const CustomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  void _handleTap(BuildContext context, int index) {
    onTap(index);

    switch (index) {
      case 0:
        if (currentIndex != 0) {
          Navigator.pushReplacementNamed(context, '/home');
        }
        break;
      case 1:
        if (currentIndex != 1) {
          Navigator.pushReplacementNamed(context, '/choose');
        }
        break;
      case 2:
        if (currentIndex != 2) {
          Navigator.pushReplacementNamed(context, '/favourites');
        }
        break;
      case 3:
        if (currentIndex != 3) {
          Navigator.pushReplacementNamed(context, '/about');
        }
        break;
      case 4:
        if (currentIndex != 4) {
          Navigator.pushReplacementNamed(context, '/profile');
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Define how many items you have
    const int numberOfItems = 5;

    return BottomNavigationBar(
      backgroundColor: const Color(0xFF181A20),
      selectedItemColor: mainBlue,
      unselectedItemColor: Colors.white54,
      // If currentIndex is invalid, set it to null so no item is selected
      currentIndex: (currentIndex >= 0 && currentIndex < numberOfItems) ? currentIndex : 0,
      selectedLabelStyle: const TextStyle(color: mainBlue),
      unselectedLabelStyle: const TextStyle(color: Colors.white54),
      onTap: (index) => _handleTap(context, index),
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.directions_car), label: "Cars"),
        BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Favourites"),
        BottomNavigationBarItem(icon: Icon(Icons.info), label: "About"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
      ],
      type: BottomNavigationBarType.fixed,
    );
  }
}