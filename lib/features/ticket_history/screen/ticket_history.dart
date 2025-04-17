import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_booking_ticket/core/models/movie_model.dart';
import 'package:movie_booking_ticket/core/widgets/bottom_nav_bar.dart';
import 'package:movie_booking_ticket/features/auth/controllers/save_token_user_service.dart';
import 'package:movie_booking_ticket/features/ticket_history/bloc/ticket_bloc.dart';
import 'package:movie_booking_ticket/features/ticket_history/bloc/ticket_event.dart';
import 'package:movie_booking_ticket/features/ticket_history/bloc/ticket_state.dart';
import 'package:movie_booking_ticket/features/ticket_history/screen/ticket_history_skeleton.dart';

class TicketHistoryScreen extends StatefulWidget {
  const TicketHistoryScreen({super.key});

  @override
  State<TicketHistoryScreen> createState() => _TicketHistoryScreenState();
}

class _TicketHistoryScreenState extends State<TicketHistoryScreen> {
  String? _userId;

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    final user = await SaveTokenUserService.getUser();
    setState(() {
      _userId = user?.userId;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_userId == null) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return BlocProvider<TicketBloc>(
      create: (_) => TicketBloc()..add(FetchTicketHistoryEvent(_userId!)),
      child: Scaffold(
        backgroundColor: Colors.black,

        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Center(
              child: const Text(
                "Tickets History",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        body: SafeArea(
          child: BlocBuilder<TicketBloc, TicketState>(
            builder: (context, state) {
              if (state.status == TicketStateStatus.loading) {
                return TicketHistorySkeleton();
              } else if (state.status == TicketStateStatus.error) {
                return Center(
                  child: Text(
                    state.errorMessage ?? "Error occurred",
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              } else if (state.orders == null || state.orders!.isEmpty) {
                return const Center(
                  child: Text(
                    "No purchased movies found",
                    style: TextStyle(color: Colors.white),
                  ),
                );
              } else {
                final List<MovieTicketModel> movies = state.orders!;
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 10,
                  ),
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.7,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                    itemCount: movies.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          context.go('/ticket/', extra: movies);
                          print('movies[index] ${movies[index].movieId}');
                        },
                        child: _buildTicketItem(movies[index]),
                      );
                    },
                  ),
                );
              }
            },
          ),
        ),
        bottomNavigationBar: const BottomNavBar(selectedIndex: 2),
      ),
    );
  }

  Widget _buildTicketItem(MovieTicketModel movie) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Builder(
              builder: (context) {
                if (movie.image != null && movie.image!.isNotEmpty) {
                  return Image.network(movie.image!, fit: BoxFit.cover);
                } else {
                  return Container(
                    color: Colors.grey,
                    child: const Icon(
                      Icons.movie,
                      color: Colors.white,
                      size: 40,
                    ),
                  );
                }
              },
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          movie.title ?? 'No Title',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
