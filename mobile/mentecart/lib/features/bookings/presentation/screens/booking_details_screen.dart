import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mentecart/core/widgets/app_loading.dart';
import 'package:mentecart/core/widgets/app_snackbar.dart';
import 'package:mentecart/features/bookings/repositories/bookings_repository_impl.dart';

import '../../../../app/network/api_client.dart';

import '../../data/datasources/bookings_remote_datasource.dart';

import '../bloc/bookings_bloc.dart';

import '../bloc/bookings_event.dart';

import '../bloc/bookings_state.dart';

import 'payhere_payment_screen.dart';

class BookingDetailsScreen extends StatelessWidget {
  final String bookingId;

  const BookingDetailsScreen({super.key, required this.bookingId});

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

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BookingsBloc(
        bookingsRepository: BookingsRepositoryImpl(
          remoteDatasource: BookingsRemoteDatasource(apiClient: ApiClient()),
        ),
      )..add(BookingDetailsFetched(bookingId)),

      child: Scaffold(
        appBar: AppBar(title: const Text('Booking Details')),

        body: BlocConsumer<BookingsBloc, BookingsState>(
          listener: (context, state) {
            if (state is BookingsFailure) {
              AppSnackbar.showError(context, state.message);
            }
          },

          builder: (context, state) {
            if (state is BookingsLoading) {
              return const Center(child: AppLoading());
            }

            if (state is BookingDetailsLoaded) {
              final booking = state.booking;

              return ListView(
                padding: const EdgeInsets.all(16),

                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          Text(
                            booking.bookingNumber,

                            style: Theme.of(context).textTheme.titleLarge,
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
                                  color: _statusColor(booking.status),

                                  borderRadius: BorderRadius.circular(30),
                                ),

                                child: Text(
                                  booking.status.toUpperCase(),

                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),

                              const SizedBox(width: 12),

                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,

                                  vertical: 6,
                                ),

                                decoration: BoxDecoration(
                                  color: _statusColor(booking.paymentStatus),

                                  borderRadius: BorderRadius.circular(30),
                                ),

                                child: Text(
                                  booking.paymentStatus.toUpperCase(),

                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 24),

                          Text(
                            'Payment Method: ${booking.paymentMethod.toUpperCase()}',
                          ),

                          const SizedBox(height: 8),

                          Text('Total Items: ${booking.totalItems}'),

                          const SizedBox(height: 8),

                          Text(
                            'Total Amount: LKR ${booking.totalAmount.toStringAsFixed(2)}',
                          ),

                          const SizedBox(height: 8),

                          Text('Booked At: ${booking.bookedAt}'),

                          if (booking.transactionId != null) ...[
                            const SizedBox(height: 8),

                            Text('Transaction ID: ${booking.transactionId}'),
                          ],

                          if (booking.paidAt != null) ...[
                            const SizedBox(height: 8),

                            Text('Paid At: ${booking.paidAt}'),
                          ],
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  Text(
                    'Booking Items',

                    style: Theme.of(context).textTheme.titleLarge,
                  ),

                  const SizedBox(height: 16),

                  ...booking.items.map((item) {
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),

                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),

                              child: Image.network(
                                item.imageUrl,

                                width: 90,

                                height: 90,

                                fit: BoxFit.cover,

                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: 90,

                                    height: 90,

                                    color: Colors.grey.shade300,

                                    child: const Icon(Icons.image),
                                  );
                                },
                              ),
                            ),

                            const SizedBox(width: 16),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,

                                children: [
                                  Text(
                                    item.title,

                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  const SizedBox(height: 8),

                                  Text('Date: ${item.selectedDate}'),

                                  Text('Time: ${item.selectedTimeSlot}'),

                                  Text('Quantity: ${item.quantity}'),

                                  Text('Duration: ${item.duration} mins'),

                                  const SizedBox(height: 8),

                                  Text(
                                    'LKR ${item.subtotal.toStringAsFixed(2)}',

                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),

                  const SizedBox(height: 32),

                  if (booking.status != 'cancelled' &&
                      booking.status != 'completed' &&
                      booking.status != 'failed')
                    SizedBox(
                      width: double.infinity,

                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),

                        onPressed: () async {
                          final confirmed = await showDialog<bool>(
                            context: context,

                            builder: (_) {
                              return AlertDialog(
                                title: const Text('Cancel Booking'),

                                content: const Text(
                                  'Are you sure you want to cancel this booking?',
                                ),

                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context, false);
                                    },

                                    child: const Text('No'),
                                  ),

                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context, true);
                                    },

                                    child: const Text('Yes'),
                                  ),
                                ],
                              );
                            },
                          );

                          if (confirmed == true && context.mounted) {
                            context.read<BookingsBloc>().add(
                              BookingCancelled(booking.id),
                            );
                          }
                        },

                        child: const Text('Cancel Booking'),
                      ),
                    ),

                  if (booking.paymentMethod == 'payhere' &&
                      booking.paymentStatus == 'pending' &&
                      booking.status != 'cancelled' &&
                      booking.status != 'failed')
                    Padding(
                      padding: const EdgeInsets.only(top: 16),

                      child: SizedBox(
                        width: double.infinity,

                        child: ElevatedButton(
                          onPressed: () async {
                            final success = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    PayHerePaymentScreen(bookingId: booking.id),
                              ),
                            );

                            if (success == true && context.mounted) {
                              context.read<BookingsBloc>().add(
                                BookingDetailsFetched(booking.id),
                              );
                            }
                          },

                          child: const Text('Pay Now'),
                        ),
                      ),
                    ),
                ],
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}
