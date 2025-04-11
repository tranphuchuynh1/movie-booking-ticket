// placeholders.dart
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:movie_booking_ticket/shimmer_effect.dart';

/// Placeholder cho phần "Now Playing" (carousel) với rating, tiêu đề và danh sách thể loại
class NowPlayingPlaceholder extends StatelessWidget {
  const NowPlayingPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Poster phim
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: ShimmerSkeleton(height: 450, width: double.infinity),
        ),
        const SizedBox(height: 10),

        // Rating: biểu tượng sao + điểm
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            ShimmerSkeleton(
              height: 18,
              width: 18,
              borderRadius: BorderRadius.all(Radius.circular(9)),
            ),
            SizedBox(width: 8),
            ShimmerSkeleton(
              height: 18,
              width: 50,
              borderRadius: BorderRadius.all(Radius.circular(4)),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Tiêu đề phim
        const ShimmerSkeleton(
          height: 25,
          width: 200,
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        const SizedBox(height: 12),

        // Danh sách thể loại
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              3,
              (index) => const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.0),
                child: ShimmerSkeleton(
                  height: 30,
                  width: 80,
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Placeholder cho từng poster phim (dùng cho các danh mục Popular, Upcoming, etc.)
class MoviePosterPlaceholder extends StatelessWidget {
  const MoviePosterPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        // Placeholder cho poster phim
        ShimmerSkeleton(
          height: 150,
          width: 100,
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        SizedBox(height: 8),
        // Placeholder cho tiêu đề phim
        ShimmerSkeleton(
          height: 14,
          width: 100,
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
      ],
    );
  }
}

/// Placeholder cho danh sách phim (Popular, Upcoming)
class MovieSectionPlaceholder extends StatelessWidget {
  const MovieSectionPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: 5, // số lượng poster placeholder muốn hiển thị khi loading
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) => const MoviePosterPlaceholder(),
      ),
    );
  }
}

/// (Tùy chọn) Widget dùng để tạo hiệu ứng fade-in cho từng placeholder với delay khác nhau
class FadeInPlaceholder extends StatefulWidget {
  final Widget child;
  final Duration delay;

  const FadeInPlaceholder({
    super.key,
    required this.child,
    required this.delay,
  });

  @override
  State<FadeInPlaceholder> createState() => _FadeInPlaceholderState();
}

class _FadeInPlaceholderState extends State<FadeInPlaceholder>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    Future.delayed(widget.delay, () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(opacity: _animation, child: widget.child);
  }
}
