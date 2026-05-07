import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:go_router/go_router.dart';
import 'package:mentecart/core/widgets/app_loading.dart';
import 'package:mentecart/core/widgets/empty_state.dart';
import 'package:mentecart/features/bookings/repositories/bookings_repository_impl.dart';

import '../../../../app/network/api_client.dart';

import '../../data/datasources/bookings_remote_datasource.dart';

import '../bloc/bookings_bloc.dart';

import '../bloc/bookings_event.dart';

import '../bloc/bookings_state.dart';

class BookingsScreen extends StatelessWidget {
  const BookingsScreen({super.key});

  Color _statusColor(String status) {
    switch (status) {
      case 'confirmed':
        return Colors.green;

      case 'pending':
        return Colors.orange;

      case 'cancelled':
        return Colors.red;

      case 'failed':
        return Colors.red;

      default:
        return Colors.grey;
    }
  }

  Color _paymentColor(String status) {
    switch (status) {
      case 'paid':
        return Colors.green;

      case 'pending':
        return Colors.orange;

      case 'unpaid':
        return Colors.red;

      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BookingsBloc(
        bookingsRepository: BookingsRepositoryImpl(
          remoteDatasource: BookingsRemoteDatasource(apiClient: ApiClient()),
        ),
      )..add(BookingsFetched()),

      child: Scaffold(
        appBar: AppBar(title: const Text('My Bookings')),

        body: BlocBuilder<BookingsBloc, BookingsState>(
          builder: (context, state) {
            if (state is BookingsLoading) {
              return const Center(child: AppLoading());
            }

            if (state is BookingsFailure) {
              return Center(child: Text(state.message));
            }

            if (state is BookingsLoaded) {
              if (state.bookings.isEmpty) {
                EmptyState(
                  icon: Icons.receipt_long_outlined,

                  title: 'No bookings yet',

                  subtitle: 'Your confirmed bookings will appear here.',

                  buttonText: 'Explore Services',

                  onPressed: () {
                    context.go('/');
                  },
                );
              }

              return RefreshIndicator(
                onRefresh: () async {
                  context.read<BookingsBloc>().add(BookingsFetched());
                },

                child: ListView.separated(
                  padding: const EdgeInsets.all(16),

                  itemCount: state.bookings.length,

                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 16),

                  itemBuilder: (context, index) {
                    final booking = state.bookings[index];

                    final firstItem = booking.items.first;

                    return InkWell(
                      borderRadius: BorderRadius.circular(16),

                      onTap: () {
                        context.push('/bookings/${booking.id}');
                      },

                      child: Card(
                        elevation: 2,

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),

                        child: Padding(
                          padding: const EdgeInsets.all(16),

                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      booking.bookingNumber,

                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleMedium,
                                    ),
                                  ),

                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,

                                      vertical: 6,
                                    ),

                                    decoration: BoxDecoration(
                                      color: _statusColor(booking.status),

                                      borderRadius: BorderRadius.circular(30),
                                    ),

                                    child: Text(
                                      booking.status.toUpperCase(),

                                      style: const TextStyle(
                                        color: Colors.white,

                                        fontSize: 12,

                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 16),

                              Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),

                                    child: Image.network(
                                      firstItem.imageUrl,

                                      width: 80,

                                      height: 80,

                                      fit: BoxFit.cover,

                                      errorBuilder:
                                          (context, error, stackTrace) {
                                            return Container(
                                              width: 80,

                                              height: 80,

                                              color: Colors.grey.shade300,

                                              child: const Icon(Icons.image),
                                            );
                                          },
                                    ),
                                  ),

                                  const SizedBox(width: 16),

                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,

                                      children: [
                                        Text(
                                          firstItem.title,

                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),

                                        const SizedBox(height: 8),

                                        Text('Date: ${firstItem.selectedDate}'),

                                        Text(
                                          'Time: ${firstItem.selectedTimeSlot}',
                                        ),

                                        Text('Items: ${booking.totalItems}'),

                                        const SizedBox(height: 8),

                                        Text(
                                          'LKR ${booking.totalAmount.toStringAsFixed(2)}',

                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 16),

                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,

                                      vertical: 6,
                                    ),

                                    decoration: BoxDecoration(
                                      color: _paymentColor(
                                        booking.paymentStatus,
                                      ),

                                      borderRadius: BorderRadius.circular(30),
                                    ),

                                    child: Text(
                                      booking.paymentStatus.toUpperCase(),

                                      style: const TextStyle(
                                        color: Colors.white,

                                        fontSize: 12,

                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),

                                  const Spacer(),

                                  Text(booking.paymentMethod.toUpperCase()),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}
