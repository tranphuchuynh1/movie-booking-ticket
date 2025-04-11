// search_skeleton.dart
import 'package:flutter/material.dart';
import 'package:movie_booking_ticket/core/widgets/shimmer_effect.dart';

/// Widget placeholder cho mỗi item kết quả tìm kiếm
class SearchResultPlaceholder extends StatelessWidget {
  const SearchResultPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          // Placeholder cho poster phim
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: const ShimmerSkeleton(height: 150, width: 100),
          ),
          const SizedBox(width: 16),
          // (tiêu đề, thể loại, rating)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Placeholder tiêu đề phim
                const ShimmerSkeleton(
                  height: 20,
                  width: 200,
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                ),
                const SizedBox(height: 8),
                // Placeholder thể loại phim
                const ShimmerSkeleton(
                  height: 16,
                  width: 150,
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                ),
                const SizedBox(height: 8),
                // Placeholder cho rating: icon và số điểm
                Row(
                  children: const [
                    ShimmerSkeleton(
                      height: 18,
                      width: 18,
                      borderRadius: BorderRadius.all(Radius.circular(9)),
                    ),
                    SizedBox(width: 4),
                    ShimmerSkeleton(
                      height: 18,
                      width: 50,
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
