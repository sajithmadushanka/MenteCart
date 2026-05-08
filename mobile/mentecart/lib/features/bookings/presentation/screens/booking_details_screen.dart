import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mentecart/app/theme/app_colors.dart';
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

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BookingsBloc(
        bookingsRepository: BookingsRepositoryImpl(
          remoteDatasource: BookingsRemoteDatasource(apiClient: ApiClient()),
        ),
      )..add(BookingDetailsFetched(bookingId)),
      child: Scaffold(
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

              final showCancel =
                  booking.status != 'cancelled' &&
                  booking.status != 'completed' &&
                  booking.status != 'failed';

              final showPay =
                  booking.paymentMethod == 'payhere' &&
                  booking.paymentStatus == 'pending' &&
                  booking.status != 'cancelled' &&
                  booking.status != 'failed';

              return Stack(
                children: [
                  CustomScrollView(
                    slivers: [
                      _DetailAppBar(bookingNumber: booking.bookingNumber),

                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 24, 20, 140),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _StatusRow(
                                status: booking.status,
                                paymentStatus: booking.paymentStatus,
                                statusColor: _statusColor(booking.status),
                                paymentColor: _statusColor(
                                  booking.paymentStatus,
                                ),
                              ),

                              const SizedBox(height: 28),

                              _SectionLabel(label: 'Booking Summary'),

                              const SizedBox(height: 16),

                              _SummaryCard(booking: booking),

                              const SizedBox(height: 28),

                              _SectionLabel(label: 'Booking Items'),

                              const SizedBox(height: 16),

                              ...booking.items.map(
                                (item) => Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: _BookingItemCard(item: item),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  if (showCancel || showPay)
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: _ActionBar(
                        showCancel: showCancel,
                        showPay: showPay,
                        bookingId: booking.id,
                        onCancelConfirmed: () {
                          context.read<BookingsBloc>().add(
                            BookingCancelled(booking.id),
                          );
                        },
                        onPaySuccess: () {
                          context.read<BookingsBloc>().add(
                            BookingDetailsFetched(booking.id),
                          );
                        },
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

class _DetailAppBar extends StatelessWidget {
  final String bookingNumber;

  const _DetailAppBar({required this.bookingNumber});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SliverAppBar(
      pinned: true,
      backgroundColor: theme.scaffoldBackgroundColor,
      elevation: 0,
      scrolledUnderElevation: 1,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Booking Details',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
              letterSpacing: -0.3,
            ),
          ),
          Text(
            bookingNumber,
            style: theme.textTheme.labelSmall?.copyWith(
              letterSpacing: 1.5,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.45),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusRow extends StatelessWidget {
  final String status;
  final String paymentStatus;
  final Color statusColor;
  final Color paymentColor;

  const _StatusRow({
    required this.status,
    required this.paymentStatus,
    required this.statusColor,
    required this.paymentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _StatusBadge(label: status, color: statusColor),
        const SizedBox(width: 10),
        _StatusBadge(label: paymentStatus, color: paymentColor),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final dynamic booking;

  const _SummaryCard({required this.booking});

  String _formatDateTime(DateTime dt) {
    final date =
        '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
    final hour = dt.hour.toString().padLeft(2, '0');
    final minute = dt.minute.toString().padLeft(2, '0');
    return '$date  $hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.5)),
      ),
      child: Column(
        children: [
          _SummaryRow(
            label: 'Payment Method',
            value: booking.paymentMethod.toUpperCase(),
            isFirst: true,
          ),
          _RowDivider(),
          _SummaryRow(label: 'Total Items', value: '${booking.totalItems}'),
          _RowDivider(),
          _SummaryRow(
            label: 'Total Amount',
            value: 'LKR ${booking.totalAmount.toStringAsFixed(2)}',
            bold: true,
          ),
          _RowDivider(),
          _SummaryRow(
            label: 'Booked At',
            value: _formatDateTime(booking.bookedAt),
          ),
          if (booking.transactionId != null) ...[
            _RowDivider(),
            _SummaryRow(label: 'Transaction ID', value: booking.transactionId!),
          ],
          if (booking.paidAt != null) ...[
            _RowDivider(),
            _SummaryRow(
              label: 'Paid At',
              value: _formatDateTime(booking.paidAt!),
              isLast: true,
            ),
          ],
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool bold;
  final bool isFirst;
  final bool isLast;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.bold = false,
    this.isFirst = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 16),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: bold ? FontWeight.w800 : FontWeight.w600,
                letterSpacing: bold ? -0.3 : 0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RowDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      thickness: 1,
      indent: 18,
      endIndent: 18,
      color: Theme.of(context).dividerColor.withValues(alpha: 0.4),
    );
  }
}

class _BookingItemCard extends StatelessWidget {
  final dynamic item;

  const _BookingItemCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.5)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            item.imageUrl,
            width: 100,
            height: 110,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: 100,
                height: 110,
                color: Colors.grey.shade200,
                child: const Icon(Icons.image, size: 28),
              );
            },
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.2,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 10),

                  _MetaRow(
                    icon: Icons.calendar_today_outlined,
                    label: item.selectedDate,
                  ),
                  const SizedBox(height: 4),
                  _MetaRow(
                    icon: Icons.access_time_outlined,
                    label: item.selectedTimeSlot,
                  ),
                  const SizedBox(height: 4),
                  _MetaRow(
                    icon: Icons.layers_outlined,
                    label: 'Qty ${item.quantity}',
                  ),
                  const SizedBox(height: 4),
                  _MetaRow(
                    icon: Icons.schedule_outlined,
                    label: '${item.duration} min',
                  ),

                  const SizedBox(height: 10),

                  Text(
                    'LKR ${item.subtotal.toStringAsFixed(2)}',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.3,
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
}

class _ActionBar extends StatelessWidget {
  final bool showCancel;
  final bool showPay;
  final String bookingId;
  final VoidCallback onCancelConfirmed;
  final VoidCallback onPaySuccess;

  const _ActionBar({
    required this.showCancel,
    required this.showPay,
    required this.bookingId,
    required this.onCancelConfirmed,
    required this.onPaySuccess,
  });

  Future<void> _confirmCancel(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Cancel Booking',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        content: const Text('Are you sure you want to cancel this booking?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('No'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Yes, Cancel'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      onCancelConfirmed();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.fromLTRB(
        20,
        16,
        20,
        16 + MediaQuery.of(context).padding.bottom,
      ),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        border: Border(top: BorderSide(color: theme.dividerColor)),
      ),
      child: Row(
        children: [
          if (showCancel)
            Expanded(
              child: SizedBox(
                height: 52,
                child: OutlinedButton(
                  onPressed: () => _confirmCancel(context),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.error,
                    side: BorderSide(
                      color: AppColors.error.withValues(alpha: 0.5),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Cancel Booking',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ),

          if (showCancel && showPay) const SizedBox(width: 12),

          if (showPay)
            Expanded(
              child: SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: () async {
                    final success = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            PayHerePaymentScreen(bookingId: bookingId),
                      ),
                    );
                    if (success == true && context.mounted) {
                      onPaySuccess();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Pay Now',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
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

class _SectionLabel extends StatelessWidget {
  final String label;

  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label.toUpperCase(),
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
        letterSpacing: 2.5,
        fontWeight: FontWeight.w700,
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.45),
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
        Flexible(
          child: Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
