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
    final theme = Theme.of(context);
    final topPadding = MediaQuery.of(context).padding.top;

    return BlocProvider(
      create: (_) => CheckoutBloc(
        bookingsRepository: BookingsRepositoryImpl(
          remoteDatasource: BookingsRemoteDatasource(apiClient: ApiClient()),
        ),
      ),
      child: Scaffold(
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

            return Stack(
              children: [
                CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(
                          24,
                          topPadding + 20,
                          24,
                          0,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () => Navigator.of(context).pop(),
                              child: Icon(
                                Icons.arrow_back,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),

                            const SizedBox(height: 24),

                            Text(
                              'Checkout',
                              style: theme.textTheme.headlineLarge?.copyWith(
                                fontWeight: FontWeight.w800,
                                letterSpacing: -1,
                                height: 1,
                              ),
                            ),

                            const SizedBox(height: 8),

                            Text(
                              'Choose how you\'d like to pay',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurface.withValues(
                                  alpha: 0.45,
                                ),
                              ),
                            ),

                            const SizedBox(height: 36),

                            _SectionLabel(label: 'Payment Method'),

                            const SizedBox(height: 16),

                            _PaymentOption(
                              value: 'cash',
                              groupValue: paymentMethod,
                              icon: Icons.payments_outlined,
                              title: 'Cash on Arrival',
                              subtitle: 'Pay in cash when the service arrives',
                              onChanged: (value) =>
                                  setState(() => paymentMethod = value!),
                            ),

                            const SizedBox(height: 12),

                            _PaymentOption(
                              value: 'payhere',
                              groupValue: paymentMethod,
                              icon: Icons.credit_card_outlined,
                              title: 'PayHere',
                              subtitle: 'Pay securely online via PayHere',
                              onChanged: (value) =>
                                  setState(() => paymentMethod = value!),
                            ),

                            const SizedBox(height: 120),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: _PlaceOrderBar(isLoading: isLoading),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _PaymentOption extends StatelessWidget {
  final String value;
  final String groupValue;
  final IconData icon;
  final String title;
  final String subtitle;
  final ValueChanged<String?> onChanged;

  const _PaymentOption({
    required this.value,
    required this.groupValue,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isSelected = value == groupValue;

    return GestureDetector(
      onTap: () => onChanged(value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary
                : theme.dividerColor.withValues(alpha: 0.6),
            width: isSelected ? 1.5 : 1,
          ),
          color: isSelected
              ? theme.colorScheme.primary.withValues(alpha: 0.05)
              : Colors.transparent,
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: isSelected
                    ? theme.colorScheme.primary.withValues(alpha: 0.1)
                    : theme.dividerColor.withValues(alpha: 0.1),
              ),
              child: Icon(
                icon,
                size: 22,
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface.withValues(alpha: 0.45),
              ),
            ),

            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.1,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            ),

            Radio<String>(
              value: value,
              groupValue: groupValue,
              onChanged: onChanged,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ],
        ),
      ),
    );
  }
}

class _PlaceOrderBar extends StatelessWidget {
  final bool isLoading;

  const _PlaceOrderBar({required this.isLoading});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.fromLTRB(
        24,
        16,
        24,
        16 + MediaQuery.of(context).padding.bottom,
      ),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        border: Border(top: BorderSide(color: theme.dividerColor)),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton(
          onPressed: isLoading
              ? null
              : () {
                  context.read<CheckoutBloc>().add(
                    CheckoutStarted(
                      (context.findAncestorStateOfType<_CheckoutScreenState>())!
                          .paymentMethod,
                    ),
                  );
                },
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: isLoading
              ? const AppLoading()
              : const Text(
                  'Place Booking',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3,
                  ),
                ),
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
