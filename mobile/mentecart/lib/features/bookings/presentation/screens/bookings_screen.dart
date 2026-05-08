import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mentecart/app/theme/app_colors.dart';
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
        return AppColors.primary;
      case 'pending':
        return AppColors.warning;
      case 'cancelled':
        return AppColors.error;
      case 'failed':
        return AppColors.error;
      default:
        return AppColors.disabled;
    }
  }

  Color _paymentColor(String status) {
    switch (status) {
      case 'paid':
        return AppColors.success;
      case 'pending':
        return AppColors.warning;
      case 'unpaid':
        return AppColors.error;
      default:
        return AppColors.disabled;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final topPadding = MediaQuery.of(context).padding.top;

    return BlocProvider(
      create: (_) => BookingsBloc(
        bookingsRepository: BookingsRepositoryImpl(
          remoteDatasource: BookingsRemoteDatasource(apiClient: ApiClient()),
        ),
      )..add(BookingsFetched()),
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(20, topPadding + 20, 20, 20),
              child: Text(
                'My Bookings',
                style: theme.textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: -1,
                  height: 1,
                ),
              ),
            ),

            Expanded(
              child: BlocBuilder<BookingsBloc, BookingsState>(
                builder: (context, state) {
                  if (state is BookingsLoading) {
                    return const Center(child: AppLoading());
                  }

                  if (state is BookingsFailure) {
                    return Center(child: Text(state.message));
                  }

                  if (state is BookingsLoaded) {
                    if (state.bookings.isEmpty) {
                      return EmptyState(
                        icon: Icons.receipt_long_outlined,
                        title: 'No bookings yet',
                        subtitle: 'Your confirmed bookings will appear here.',
                        buttonText: 'Explore Services',
                        onPressed: () => context.go('/'),
                      );
                    }

                    return RefreshIndicator(
                      onRefresh: () async {
                        context.read<BookingsBloc>().add(BookingsFetched());
                      },
                      child: ListView.separated(
                        padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
                        itemCount: state.bookings.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 16),
                        itemBuilder: (context, index) {
                          final booking = state.bookings[index];
                          final firstItem = booking.items.first;

                          return _BookingCard(
                            booking: booking,
                            firstItem: firstItem,
                            statusColor: _statusColor(booking.status),
                            paymentColor: _paymentColor(booking.paymentStatus),
                            onTap: () =>
                                context.push('/bookings/${booking.id}'),
                          );
                        },
                      ),
                    );
                  }

                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BookingCard extends StatelessWidget {
  final dynamic booking;
  final dynamic firstItem;
  final Color statusColor;
  final Color paymentColor;
  final VoidCallback onTap;

  const _BookingCard({
    required this.booking,
    required this.firstItem,
    required this.statusColor,
    required this.paymentColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: theme.dividerColor.withValues(alpha: 0.5)),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            _CardHeader(
              bookingNumber: booking.bookingNumber,
              status: booking.status,
              statusColor: statusColor,
            ),

            Divider(
              height: 1,
              thickness: 1,
              color: theme.dividerColor.withValues(alpha: 0.4),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ServiceThumbnail(imageUrl: firstItem.imageUrl),

                  const SizedBox(width: 16),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          firstItem.title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.2,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),

                        const SizedBox(height: 10),

                        _MetaRow(
                          icon: Icons.calendar_today_outlined,
                          label: firstItem.selectedDate,
                        ),

                        const SizedBox(height: 5),

                        _MetaRow(
                          icon: Icons.access_time_outlined,
                          label: firstItem.selectedTimeSlot,
                        ),

                        const SizedBox(height: 5),

                        _MetaRow(
                          icon: Icons.layers_outlined,
                          label:
                              '${booking.totalItems} item${booking.totalItems == 1 ? '' : 's'}',
                        ),

                        const SizedBox(height: 12),

                        Text(
                          'LKR ${booking.totalAmount.toStringAsFixed(2)}',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Divider(
              height: 1,
              thickness: 1,
              color: theme.dividerColor.withValues(alpha: 0.4),
            ),

            _CardFooter(
              paymentStatus: booking.paymentStatus,
              paymentColor: paymentColor,
              paymentMethod: booking.paymentMethod,
            ),
          ],
        ),
      ),
    );
  }
}

class _CardHeader extends StatelessWidget {
  final String bookingNumber;
  final String status;
  final Color statusColor;

  const _CardHeader({
    required this.bookingNumber,
    required this.status,
    required this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'BOOKING',
                  style: theme.textTheme.labelSmall?.copyWith(
                    letterSpacing: 2,
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.45),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  bookingNumber,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
          ),

          _StatusBadge(label: status, color: statusColor),
        ],
      ),
    );
  }
}

class _CardFooter extends StatelessWidget {
  final String paymentStatus;
  final Color paymentColor;
  final String paymentMethod;

  const _CardFooter({
    required this.paymentStatus,
    required this.paymentColor,
    required this.paymentMethod,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          _StatusBadge(label: paymentStatus, color: paymentColor),

          const Spacer(),

          Row(
            children: [
              Icon(
                Icons.credit_card_outlined,
                size: 15,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.45),
              ),
              const SizedBox(width: 6),
              Text(
                paymentMethod.toUpperCase(),
                style: theme.textTheme.labelSmall?.copyWith(
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.55),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String label;
  final Color color;

  const _StatusBadge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: color.withValues(alpha: 0.35), width: 1),
      ),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 1,
        ),
      ),
    );
  }
}

class _ServiceThumbnail extends StatelessWidget {
  final String imageUrl;

  const _ServiceThumbnail({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Image.network(
        imageUrl,
        width: 84,
        height: 84,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: 84,
            height: 84,
            color: Colors.grey.shade200,
            child: const Icon(Icons.image, size: 28),
          );
        },
      ),
    );
  }
}

class _MetaRow extends StatelessWidget {
  final IconData icon;
  final String label;

  const _MetaRow({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Icon(
          icon,
          size: 13,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.45),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
