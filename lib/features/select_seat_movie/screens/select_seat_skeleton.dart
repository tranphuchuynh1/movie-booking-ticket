import 'package:flutter/material.dart';
import 'package:movie_booking_ticket/core/widgets/shimmer_effect.dart';

class SelectSeatSkeleton extends StatelessWidget {
  const SelectSeatSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          // Background giả lập ảnh poster
          Positioned(
            left: 0,
            right: 0,
            height: 300,
            child: ShimmerSkeleton(
              height: 300,
              width: double.infinity,
              borderRadius: BorderRadius.zero,
            ),
          ),

          // Overlay mờ
          Positioned(
            left: 0,
            right: 0,
            height: 300,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.3),
                    Colors.black.withOpacity(0.7),
                    Colors.black,
                  ],
                  stops: const [0.0, 0.3, 0.7, 1.0],
                ),
              ),
            ),
          ),

          // Nút đóng giả lập
          Positioned(
            top: 40,
            left: 16,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(8),
              child: const Icon(Icons.close, color: Colors.white, size: 20),
            ),
          ),

          // Main content skeleton
          Positioned.fill(
            top: 250,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 15),

                  // Thanh chỉ thị
                  Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Ghế giả
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: 5,
                      itemBuilder:
                          (_, __) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                8,
                                (index) => Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 4,
                                  ),
                                  child: ShimmerSkeleton(
                                    width: 32,
                                    height: 32,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                              ),
                            ),
                          ),
                    ),
                  ),

                  // Chọn ngày
                  _buildHorizontalSkeleton(height: 80),

                  // Chọn giờ
                  _buildHorizontalSkeleton(height: 50),

                  // Tổng tiền và nút mua vé
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            ShimmerSkeleton(height: 16, width: 100),
                            SizedBox(height: 6),
                            ShimmerSkeleton(height: 20, width: 120),
                          ],
                        ),
                        const ShimmerSkeleton(
                          height: 40,
                          width: 100,
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHorizontalSkeleton({required double height}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
      child: SizedBox(
        height: height,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: 6,
          separatorBuilder: (_, __) => const SizedBox(width: 10),
          itemBuilder:
              (_, __) => ShimmerSkeleton(
                height: height - 20,
                width: 60,
                borderRadius: BorderRadius.circular(12),
              ),
        ),
      ),
    );
  }
}
