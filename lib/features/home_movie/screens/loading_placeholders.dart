// placeholders.dart
import 'package:flutter/material.dart';
import 'package:movie_booking_ticket/shimmer_effect.dart';

/// Placeholder cho nội dung phần Now Playing (không bao gồm tiêu đề)
class NowPlayingPlaceholder extends StatelessWidget {
  const NowPlayingPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Giả lập placeholder cho Carousel (chiều cao 450)
        const ShimmerSkeleton(
          height: 450,
          width: double.infinity,
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        const SizedBox(height: 10),
        // Giả lập placeholder cho phần chi tiết phim (chiều cao 100)
        const ShimmerSkeleton(
          height: 100,
          width: double.infinity,
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ],
    );
  }
}

/// Placeholder cho nội dung phần danh sách phim (Popular, Upcoming)
class MovieSectionPlaceholder extends StatelessWidget {
  const MovieSectionPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    // Giả lập placeholder cho phần list ngang (chiều cao 180)
    return const ShimmerSkeleton(height: 180, width: double.infinity);
  }
}
