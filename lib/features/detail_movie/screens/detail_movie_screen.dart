import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_booking_ticket/core/models/movie_model.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../../core/dio/dio_client.dart';
import '../../select_seat_movie/controllers/select_seat_movie_controller.dart';
import '../bloc/detail_movie_bloc.dart';
import 'dart:convert';

import 'detail_movie_skeleton.dart';

class MovieDetailScreen extends StatefulWidget {
  final String movieId;

  const MovieDetailScreen({
    super.key,
    required this.movieId,
  });

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  final MovieDetailBloc _detailBloc = MovieDetailBloc();
  bool _isDescriptionExpanded = false;
  bool _hasCheckedShowtimes = false;

  @override
  void initState() {
    super.initState();
    _hasCheckedShowtimes = false;
    _detailBloc.add(FetchMovieDetailEvent(widget.movieId));
  }

  @override
  void dispose() {
    _detailBloc.close();
    super.dispose();
  }

  ImageProvider _getProperImageProvider(String? url) {
    if (url == null || url.isEmpty) {
      return const NetworkImage('https://upload.wikimedia.org/wikipedia/commons/thumb/5/50/User_icon-cp.svg/1656px-User_icon-cp.svg.png');
    }

    if (url.startsWith('data:image')) {
      // xử lý hình ảnh dạng base64
      final bytes = base64Decode(url.split(',')[1]);
      return MemoryImage(bytes);
    } else {
      // URL thông thường
      return NetworkImage(url);
    }
  }

  String _extractAgeRating(String? rating) {
    if (rating == null || rating.isEmpty) {
      return 'T18';
    }
    if (rating.contains(' - ')) {
      return rating.split(' - ')[0].trim();
    }
    return rating;
  }

  void _checkShowtimesAvailability(MovieModel movieModel) async {
    // Kiểm tra nếu đã từng check rồi thì không check nữa
    if (_hasCheckedShowtimes) return;

    try {
      final bookingController = BookingController(dio: DioClient.instance);
      final showtimes = await bookingController.getShowtimes(movieModel.movieId!);

      // Lọc các suất chiếu còn hiệu lực
      final now = DateTime.now();
      final validShowtimes = showtimes.where((showtime) {
        if (showtime.date == null || showtime.time == null) return false;

        try {
          final dateTime = DateTime.parse(showtime.date!);
          final timeParts = showtime.time!.split(':');

          final showtimeDateTime = DateTime(
            dateTime.year,
            dateTime.month,
            dateTime.day,
            int.parse(timeParts[0]),
            int.parse(timeParts[1]),
          );

          return showtimeDateTime.isAfter(now);
        } catch (_) {
          return false;
        }
      }).toList();

      // Đánh dấu đã check
      _hasCheckedShowtimes = true;

      // Kiểm tra xem màn hình hiện tại có phải là màn hình chi tiết không
      if (ModalRoute.of(context)?.isCurrent == true) {
        // Nếu không có suất chiếu nào còn hiệu lực
        if (validShowtimes.isEmpty) {
          // Thêm delay để tránh conflict với navigation
          await Future.delayed(const Duration(milliseconds: 300));

          // Kiểm tra lại xem màn hình vẫn còn active không
          if (mounted) {
            await _showNoShowtimesDialog();
          }
        }
      }
    } catch (e) {
      print('Error checking showtimes: $e');
    }
  }

  // Phương thức hiển thị dialog
  Future<void> _showNoShowtimesDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            backgroundColor: Colors.black87,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              side: BorderSide(color: Colors.red, width: 2),
            ),
            title: Center(
              child: Image.asset(
                'assets/icons/icons-no-date.png',
                height: 100,
                width: 100,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Phim tạm thời chưa có suất chiếu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    minimumSize: const Size(double.infinity, 45),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22),
                    ),
                  ),
                  onPressed: () {
                    // context.go('/detail',extra: widget.movieId);
                    context.pop();
                  },
                  child: const Text(
                    'Trở Lại',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _detailBloc,
      child: BlocBuilder<MovieDetailBloc, MovieDetailState>(
        builder: (context, state) {
          if (state.status == MovieDetailStatus.loading) {
            return const Scaffold(
              backgroundColor: Colors.black,
              body: Center(
                child: DetailMovieSkeleton()
              ),
            );
          } else if (state.status == MovieDetailStatus.success && state.movieDetail != null) {
            return _buildContent(context, state.movieDetail!);
          } else {
            return Scaffold(
              backgroundColor: Colors.black,
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red, size: 48),
                    const SizedBox(height: 16),
                    Text(
                      state.errorMessage ?? 'Đã xảy ra lỗi khi tải thông tin phim',
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        _detailBloc.add(FetchMovieDetailEvent(widget.movieId));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepOrange,
                      ),
                      child: const Text('Thử lại'),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, MovieModel movieModel) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMoviePoster(context, movieModel),
            _buildMovieInfo(movieModel),
            _buildMovieDetails(context, movieModel),
            _buildDescription(movieModel),
            _buildCastSection(context, movieModel),
            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomButton(context, movieModel),
    );
  }

  Widget _buildMoviePoster(BuildContext context, MovieModel movieModel) {
    // Tìm URL hình ảnh từ danh sách media
    String? posterImageUrl;
    if (movieModel.media != null && movieModel.media!.isNotEmpty) {
      final imageMedia = movieModel.media!.firstWhere(
            (media) => media.mediaType == 'Image',
        orElse: () => MediaModel(),
      );
      posterImageUrl = imageMedia.mediaURL;
    }

    return Stack(
      children: [
        // Img nền
        Container(
          height: 400,
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(posterImageUrl ?? 'https://via.placeholder.com/400x600?text=No+Image'),
              fit: BoxFit.cover,
            ),
          ),
        ),
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
        // button đóng
        Positioned(
          top: 40,
          left: 16,
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 20),
              onPressed: ()  {
                  context.go('/home', extra: widget.movieId);
              },
            ),
          ),
        ),
        // Poster phim
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
                image: DecorationImage(
                  image: NetworkImage(posterImageUrl ?? 'https://via.placeholder.com/200x300?text=No+Image'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMovieInfo(MovieModel movieModel) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // thời lượng phim (duration)
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.access_time, color: Colors.white54, size: 16),
                const SizedBox(width: 4),
                Text(
                  movieModel.duration != null ? '${movieModel.duration} phút' : 'Đang cập nhật',
                  style: const TextStyle(color: Colors.white54),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // tên movie (title) --
          Center(
            child: Text(
              movieModel.title ?? "Không có tiêu đề",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 12),
          // thể lọai (genres) --
          Center(
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: (movieModel.genres ?? []).map((genre) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white24),
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.black,
                  ),
                  child: Text(
                    genre,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMovieDetails(BuildContext context, MovieModel movieModel) {
    String? trailerUrl;
    if (movieModel.media != null && movieModel.media!.isNotEmpty) {
      final videoMedia = movieModel.media!.firstWhere(
            (media) => media.mediaType == 'Video',
        orElse: () => MediaModel(),
      );
      trailerUrl = videoMedia.mediaURL;
    }

    String? youtubeId;
    if (trailerUrl != null && trailerUrl.isNotEmpty) {
      youtubeId = YoutubePlayer.convertUrlToId(trailerUrl);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  const Icon(Icons.star, color: Colors.yellow, size: 20),
                  const SizedBox(width: 4),
                  Text(
                    '${movieModel.rating ?? 0}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    movieModel.releaseDate?.split('T')[0] ?? '',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _extractAgeRating(movieModel.ageRating),
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          ElevatedButton.icon(
            onPressed: youtubeId != null
                ? () {
              showDialog(
                context: context,
                builder: (context) => TrailerDialog(videoId: youtubeId!),
              );
            }
                : null,
            icon: const Icon(Icons.play_circle, color: Colors.white),
            label: const Text('Trailer', style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepOrange,
              disabledBackgroundColor: Colors.grey,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescription(MovieModel movieModel) {
    if (movieModel.description == null || movieModel.description!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Nội dung phim',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 300),
            crossFadeState: _isDescriptionExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            firstChild: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movieModel.description!.length > 200
                      ? '${movieModel.description!.substring(0, 200)}...'
                      : movieModel.description!,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
                if (movieModel.description!.length > 100)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          _isDescriptionExpanded = true;
                        });
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text(
                        'Xem thêm',
                        style: TextStyle(
                          color: Colors.deepOrange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            secondChild: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movieModel.description!,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        _isDescriptionExpanded = false;
                      });
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text(
                      'Thu gọn',
                      style: TextStyle(
                        color: Colors.deepOrange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCastSection(BuildContext context, MovieModel movieModel) {
    if (movieModel.actors == null || movieModel.actors!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Text(
            // AppLocalizations.of(context)?.topCast ?? 'Diễn viên',
            'Diễn viên',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 140,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: movieModel.actors!.length,
            itemBuilder: (context, index) {
              final actor = movieModel.actors![index];
              return Padding(
                padding: EdgeInsets.only(
                  left: index == 0 ? 16.0 : 8.0,
                  right: 8.0,
                ),
                child: Column(
                  children: [
                    // Avatar của diễn viên
                    CircleAvatar(
                      radius: 35,
                      backgroundImage: _getProperImageProvider(actor.imageURL),
                      backgroundColor: Colors.grey,
                    ),
                    const SizedBox(height: 8),
                    // Container chứa tên diễn viên với chiều cao cố định
                    SizedBox(
                      width: 70,
                      height: 40, // Chiều cao cố định cho phần tên diễn viên
                      child: Center(
                        child: Text(
                          actor.name ?? '',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 70,
                      child: Text(
                        actor.role ?? '',
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 11,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBottomButton(BuildContext context, MovieModel movieModel) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 90.0, vertical: 16.0),
      child: ElevatedButton(
        onPressed: () async {
          try {
            final bookingController = BookingController(dio: DioClient.instance);
            final showtimes = await bookingController.getShowtimes(movieModel.movieId!);

            // Kiểm tra xem có dữ liệu suất chiếu không
            if (showtimes.isEmpty) {
              // Nếu không có suất chiếu nào, hiển thị dialog
              await _showNoShowtimesDialog();
              return;
            }

            final now = DateTime.now();
            final validShowtimes = showtimes.where((showtime) {
              if (showtime.date == null || showtime.time == null) return false;

              try {
                final dateTime = DateTime.parse(showtime.date!);
                final timeParts = showtime.time!.split(':');

                final showtimeDateTime = DateTime(
                  dateTime.year,
                  dateTime.month,
                  dateTime.day,
                  int.parse(timeParts[0]),
                  int.parse(timeParts[1]),
                );

                return showtimeDateTime.isAfter(now);
              } catch (_) {
                return false;
              }
            }).toList();

            if (validShowtimes.isEmpty) {
              // Hiển thị dialog nếu không có suất chiếu nào còn hiệu lực
              await _showNoShowtimesDialog();
            } else {
              // Chuyển màn hình nếu có suất chiếu
              context.go('/select_seat', extra: movieModel.movieId);
            }
          } catch (e) {
            // Nếu có lỗi khi gọi API, hiển thị dialog
            await _showNoShowtimesDialog();
            print('Error checking showtimes: $e');
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepOrange,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: const Text(
          'Đặt Ghế',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class TrailerDialog extends StatelessWidget {
  final String videoId;

  const TrailerDialog({super.key, required this.videoId});

  @override
  Widget build(BuildContext context) {
    final controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );

    return Dialog(
      backgroundColor: Colors.black87,
      insetPadding: const EdgeInsets.all(16),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Stack(
          children: [
            YoutubePlayer(
              controller: controller,
              showVideoProgressIndicator: true,
              progressIndicatorColor: Colors.red,
              onReady: () {
                print("YouTube player ready");
              },
              onEnded: (data) {
                Navigator.of(context).pop();
              },
            ),
            Positioned(
              top: 8,
              right: 8,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}