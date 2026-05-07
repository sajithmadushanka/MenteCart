import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mentecart/core/widgets/app_loading.dart';
import 'package:mentecart/core/widgets/app_snackbar.dart';
import 'package:mentecart/features/bookings/presentation/screens/payhere_payment_screen.dart';
import 'package:mentecart/features/bookings/repositories/bookings_repository_impl.dart';
import 'package:mentecart/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:mentecart/features/cart/presentation/bloc/cart_event.dart';

import '../../../../app/network/api_client.dart';

import '../../data/datasources/bookings_remote_datasource.dart';

import '../bloc/checkout_bloc.dart';
import '../bloc/checkout_event.dart';
import '../bloc/checkout_state.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String paymentMethod = 'cash';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CheckoutBloc(
        bookingsRepository: BookingsRepositoryImpl(
          remoteDatasource: BookingsRemoteDatasource(apiClient: ApiClient()),
        ),
      ),

      child: Scaffold(
        appBar: AppBar(title: const Text('Checkout')),

        body: BlocConsumer<CheckoutBloc, CheckoutState>(
          listener: (context, state) async {
            if (state is CheckoutFailure) {
              AppSnackbar.showError(context, state.message);
            }

            if (state is CheckoutSuccess) {
              context.read<CartBloc>().add(CartFetched());

              if (state.booking.paymentMethod == 'payhere') {
                final success = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        PayHerePaymentScreen(bookingId: state.booking.id),
                  ),
                );

                if (success == true && context.mounted) {
                  context.go(
                    '/booking-success',

                    extra: {
                      'bookingId': state.booking.id,

                      'bookingNumber': state.booking.bookingNumber,

                      'paid': true,
                    },
                  );
                }

                return;
              }

              if (context.mounted) {
                context.go(
                  '/booking-success',

                  extra: {
                    'bookingId': state.booking.id,

                    'bookingNumber': state.booking.bookingNumber,

                    'paid': state.booking.paymentStatus == 'paid',
                  },
                );
              }
            }
          },

          builder: (context, state) {
            final isLoading = state is CheckoutLoading;

            return Padding(
              padding: const EdgeInsets.all(16),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    'Select Payment Method',

                    style: Theme.of(context).textTheme.titleLarge,
                  ),

                  const SizedBox(height: 24),

                  RadioListTile(
                    value: 'cash',

                    groupValue: paymentMethod,

                    title: const Text('Cash On Arrival'),

                    onChanged: (value) {
                      setState(() {
                        paymentMethod = value!;
                      });
                    },
                  ),

                  RadioListTile(
                    value: 'payhere',

                    groupValue: paymentMethod,

                    title: const Text('PayHere Online Payment'),

                    onChanged: (value) {
                      setState(() {
                        paymentMethod = value!;
                      });
                    },
                  ),

                  const Spacer(),

                  SizedBox(
                    width: double.infinity,

                    child: ElevatedButton(
                      onPressed: isLoading
                          ? null
                          : () {
                              context.read<CheckoutBloc>().add(
                                CheckoutStarted(paymentMethod),
                              );
                            },

                      child: isLoading
                          ? const AppLoading()
                          : const Text('Place Booking'),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
