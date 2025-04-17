// ticket_history_skeleton.dart
import 'package:flutter/material.dart';
import 'package:movie_booking_ticket/core/widgets/shimmer_effect.dart';

class TicketHistorySkeleton extends StatelessWidget {
  const TicketHistorySkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.7,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: 6, // hiển thị 6 placeholder
        itemBuilder: (context, index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Placeholder cho ảnh poster
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: const ShimmerSkeleton(
                    height: double.infinity,
                    width: double.infinity,
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              // Placeholder cho tiêu đề phim
              const ShimmerSkeleton(
                height: 16,
                width: double.infinity,
                borderRadius: BorderRadius.all(Radius.circular(4)),
              ),
            ],
          );
        },
      ),
    );
  }
}
