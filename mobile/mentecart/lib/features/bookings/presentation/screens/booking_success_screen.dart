import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BookingSuccessScreen extends StatelessWidget {
  final String bookingId;
  final String bookingNumber;
  final bool paid;

  const BookingSuccessScreen({
    super.key,
    required this.bookingId,
    required this.bookingNumber,
    required this.paid,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),

              _SuccessIcon(),

              const SizedBox(height: 36),

              Text(
                'Booking\nSuccessful',
                textAlign: TextAlign.center,
                style: theme.textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: -1.5,
                  height: 1.1,
                ),
              ),

              const SizedBox(height: 16),

              Text(
                paid
                    ? 'Your payment was completed successfully.'
                    : 'Your booking was placed successfully.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  height: 1.6,
                ),
              ),

              const SizedBox(height: 40),

              _BookingNumberCard(bookingNumber: bookingNumber),

              const Spacer(),

              _ActionButtons(bookingId: bookingId),

              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}

class _SuccessIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // final theme = Theme.of(context);

    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.green.withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: Container(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.green.withValues(alpha: 0.1),
        ),
        child: const Icon(Icons.check_rounded, size: 44, color: Colors.green),
      ),
    );
  }
}

class _BookingNumberCard extends StatelessWidget {
  final String bookingNumber;

  const _BookingNumberCard({required this.bookingNumber});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.5)),
      ),
      child: Column(
        children: [
          Text(
            'BOOKING NUMBER',
            style: theme.textTheme.labelSmall?.copyWith(
              letterSpacing: 2.5,
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
            ),
          ),

          const SizedBox(height: 10),

          Text(
            bookingNumber,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButtons extends StatelessWidget {
  final String bookingId;

  const _ActionButtons({required this.bookingId});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: () => context.go('/bookings/$bookingId'),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: const Text(
              'View Booking',
              style: TextStyle(fontWeight: FontWeight.w700, letterSpacing: 0.3),
            ),
          ),
        ),

        const SizedBox(height: 12),

        SizedBox(
          width: double.infinity,
          height: 52,
          child: OutlinedButton(
            onPressed: () => context.go('/'),
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: const Text(
              'Back to Home',
              style: TextStyle(fontWeight: FontWeight.w700, letterSpacing: 0.3),
            ),
          ),
        ),
      ],
    );
  }
}
