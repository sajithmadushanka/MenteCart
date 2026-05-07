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
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              Container(
                width: 140,

                height: 140,

                decoration: BoxDecoration(
                  color: Colors.green.shade100,

                  shape: BoxShape.circle,
                ),

                child: Icon(
                  Icons.check_circle,

                  size: 90,

                  color: Colors.green.shade700,
                ),
              ),

              const SizedBox(height: 40),

              Text(
                'Booking Successful',

                style: Theme.of(context).textTheme.headlineMedium,
              ),

              const SizedBox(height: 16),

              Text(
                paid
                    ? 'Your payment was completed successfully.'
                    : 'Your booking was placed successfully.',

                textAlign: TextAlign.center,

                style: TextStyle(color: Colors.grey.shade700, fontSize: 16),
              ),

              const SizedBox(height: 32),

              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),

                  child: Column(
                    children: [
                      const Text('Booking Number'),

                      const SizedBox(height: 12),

                      Text(
                        bookingNumber,

                        style: const TextStyle(
                          fontWeight: FontWeight.bold,

                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,

                child: ElevatedButton(
                  onPressed: () {
                    context.go('/bookings/$bookingId');
                  },

                  child: const Text('View Booking'),
                ),
              ),

              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,

                child: OutlinedButton(
                  onPressed: () {
                    context.go('/');
                  },

                  child: const Text('Back To Home'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
