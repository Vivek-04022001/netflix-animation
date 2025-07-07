import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final GlobalKey endKey;
  final bool animationDone;

  const BottomNavBar({
    super.key,
    required this.endKey,
    required this.animationDone,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Animated "N" icon
          SizedBox(
            key: endKey,
            width: 40,
            height: 40,
            child: Opacity(
              opacity: animationDone ? 1.0 : 0.0,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Text(
                    'N',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Additional icons
          const Icon(Icons.video_library),
          const Icon(Icons.home),
          const Icon(Icons.search),
          const Icon(Icons.settings),
        ],
      ),
    );
  }
}
