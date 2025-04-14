import 'package:flutter/material.dart';
import 'package:movie_booking_ticket/core/widgets/shimmer_effect.dart';

class DetailMovieSkeleton extends StatelessWidget {
  const DetailMovieSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Phần poster nền với gradient và poster chính
            Stack(
              children: [
                // Skeleton cho ảnh nền (backdrop)
                ShimmerSkeleton(height: 400, width: double.infinity),
                // Gradient overlay
                Container(
                  height: 400,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.1),
                        Colors.black.withOpacity(0.9),
                      ],
                      stops: const [0.1, 0.5],
                    ),
                  ),
                ),
                // Button đóng (bạn có thể giữ nguyên hoặc tạo hiệu ứng skeleton)
                Positioned(
                  top: 40,
                  left: 16,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 20,
                      ),
                      onPressed: () {},
                    ),
                  ),
                ),
                // Skeleton cho poster phim chính (được hiển thị phía dưới, có hiệu ứng shadow)
                Positioned(
                  bottom: -25,
                  left: 0,
                  right: 0,
                  child: Container(
                    alignment: Alignment.center,
                    child: Container(
                      height: 300,
                      width: 200,
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            spreadRadius: 1,
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: const ShimmerSkeleton(height: 300, width: 200),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 60,
            ), // Khoảng cách để bù phần poster bị chồng lên
            // Phần thông tin phim (duration, tiêu đề và danh sách thể loại)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Skeleton cho row thời lượng phim
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ShimmerSkeleton(
                        height: 16,
                        width: 16,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      const SizedBox(width: 4),
                      ShimmerSkeleton(height: 16, width: 80),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Skeleton cho tiêu đề phim
                  Center(child: ShimmerSkeleton(height: 24, width: 200)),
                  const SizedBox(height: 12),
                  // Skeleton cho danh sách thể loại (dùng Wrap với 3 item)
                  Center(
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      alignment: WrapAlignment.center,
                      children: List.generate(3, (index) {
                        return ShimmerSkeleton(
                          height: 16,
                          width: 50,
                          borderRadius: BorderRadius.circular(12),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
            // Phần chi tiết phim (rating, ngày phát hành, age rating, nút trailer)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        ShimmerSkeleton(
                          height: 18,
                          width: 18,
                          borderRadius: BorderRadius.circular(9),
                        ),
                        const SizedBox(width: 4),
                        ShimmerSkeleton(
                          height: 18,
                          width: 50,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        const SizedBox(width: 12),
                        ShimmerSkeleton(height: 18, width: 80),
                        const SizedBox(width: 12),
                        ShimmerSkeleton(height: 18, width: 40),
                      ],
                    ),
                  ),
                  // Skeleton cho nút "Trailer"
                  ShimmerSkeleton(
                    height: 36,
                    width: 80,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Phần Mô tả phim (Description)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Skeleton tiêu đề mô tả
                  ShimmerSkeleton(height: 20, width: 150),
                  const SizedBox(height: 8),
                  // Skeleton cho nội dung mô tả (vài dòng văn bản)
                  ShimmerSkeleton(height: 80, width: double.infinity),
                ],
              ),
            ),
            // Phần Diễn viên (Cast Section)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12.0,
              ),
              child: ShimmerSkeleton(height: 20, width: 120),
            ),
            SizedBox(
              height: 140,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: 4,
                separatorBuilder: (context, index) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      // Skeleton cho avatar diễn viên
                      CircleAvatar(
                        radius: 35,
                        backgroundColor: Colors.grey[800],
                        child: ClipOval(
                          child: ShimmerSkeleton(
                            height: 70,
                            width: 70,
                            borderRadius: BorderRadius.circular(35),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Skeleton cho tên diễn viên
                      ShimmerSkeleton(height: 14, width: 70),
                      const SizedBox(height: 4),
                      // Skeleton cho vai diễn
                      ShimmerSkeleton(height: 12, width: 50),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      // Skeleton cho nút "Select Seats" ở phần dưới cùng
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 90.0, vertical: 16.0),
        child: ShimmerSkeleton(
          height: 50,
          width: double.infinity,
          borderRadius: BorderRadius.circular(25),
        ),
      ),
    );
  }
}
