import 'package:flutter/material.dart';

class PositionedFactory {
  static Positioned create(int pageCount, int currentPage) {
    return Positioned(
      bottom: 28,
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(pageCount,
          (index) => AnimatedContainer(
            duration: Duration(milliseconds: 300),
            margin: EdgeInsets.symmetric(horizontal: 4),
            width: currentPage == index ? 12 : 8,
            height: currentPage == index ? 12 : 8,
            decoration: BoxDecoration(
              color: currentPage == index ? const Color(0xFFE0E0E0) : const Color(0xFFA8A8A8),
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}
