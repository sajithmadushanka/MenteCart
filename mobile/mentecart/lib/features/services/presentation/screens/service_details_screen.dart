import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mentecart/core/widgets/app_loading.dart';
import 'package:mentecart/core/widgets/app_snackbar.dart';
import 'package:mentecart/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:mentecart/features/cart/presentation/bloc/cart_event.dart';
import 'package:mentecart/features/cart/presentation/bloc/cart_state.dart';
import 'package:mentecart/features/services/models/service_model.dart';
import 'package:mentecart/features/services/repositories/services_repository_impl.dart';

import '../../../../app/network/api_client.dart';

import '../../data/datasources/services_remote_datasource.dart';

class ServiceDetailsScreen extends StatefulWidget {
  final String serviceId;

  const ServiceDetailsScreen({super.key, required this.serviceId});

  @override
  State<ServiceDetailsScreen> createState() => _ServiceDetailsScreenState();
}

class _ServiceDetailsScreenState extends State<ServiceDetailsScreen> {
  late Future<ServiceModel> _futureService;

  @override
  void initState() {
    super.initState();
    _futureService = ServicesRepositoryImpl(
      remoteDatasource: ServicesRemoteDatasource(apiClient: ApiClient()),
    ).getServiceById(widget.serviceId);
  }

  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  int quantity = 1;

  Future<void> pickDate() async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: FutureBuilder<ServiceModel>(
        future: _futureService,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: AppLoading());
          }

          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          if (!snapshot.hasData) {
            return const Center(child: Text('Service not found'));
          }

          final service = snapshot.data!;

          return Stack(
            children: [
              CustomScrollView(
                slivers: [
                  SliverAppBar(
                    expandedHeight: 340,
                    pinned: true,
                    stretch: true,
                    backgroundColor: theme.scaffoldBackgroundColor,
                    flexibleSpace: FlexibleSpaceBar(
                      stretchModes: const [
                        StretchMode.zoomBackground,
                        StretchMode.fadeTitle,
                      ],
                      background: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.network(
                            service.imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey.shade200,
                                child: const Center(
                                  child: Icon(Icons.image, size: 72),
                                ),
                              );
                            },
                          ),
                          DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withValues(alpha: 0.55),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SliverToBoxAdapter(
                    child: Transform.translate(
                      offset: const Offset(0, -28),
                      child: Container(
                        decoration: BoxDecoration(
                          color: theme.scaffoldBackgroundColor,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(28),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(24, 32, 24, 120),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 20),
                              Row(
                                children: [
                                  _TagChip(label: service.category),
                                  const SizedBox(width: 8),
                                  _TagChip(
                                    label: '${service.duration} min',
                                    icon: Icons.schedule_outlined,
                                  ),
                                ],
                              ),

                              const SizedBox(height: 16),

                              Text(
                                service.title,
                                style: theme.textTheme.headlineMedium?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.5,
                                  height: 1.15,
                                ),
                              ),

                              const SizedBox(height: 20),

                              _Divider(),

                              const SizedBox(height: 20),

                              Text(
                                service.description,
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  height: 1.7,
                                  letterSpacing: 0.1,
                                ),
                              ),

                              const SizedBox(height: 32),

                              _SectionLabel(label: 'Booking Details'),

                              const SizedBox(height: 16),

                              _PickerTile(
                                icon: Icons.calendar_today_outlined,
                                label: 'Date',
                                value: selectedDate == null
                                    ? 'Select a date'
                                    : selectedDate!
                                          .toIso8601String()
                                          .split('T')
                                          .first,
                                onTap: pickDate,
                              ),

                              const SizedBox(height: 12),

                              _PickerTile(
                                icon: Icons.access_time_outlined,
                                label: 'Time Slot',
                                value: selectedTime == null
                                    ? 'Select a time'
                                    : selectedTime!.format(context),
                                onTap: pickTime,
                              ),

                              const SizedBox(height: 24),

                              _SectionLabel(label: 'Quantity'),

                              const SizedBox(height: 12),

                              _QuantitySelector(
                                quantity: quantity,
                                onDecrement: quantity > 1
                                    ? () => setState(() => quantity--)
                                    : null,
                                onIncrement: () => setState(() => quantity++),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: _BottomBar(
                  service: service,
                  quantity: quantity,
                  onAddToCart: () {
                    if (selectedDate == null) {
                      AppSnackbar.showInfo(context, 'Please select a date');
                      return;
                    }
                    if (selectedTime == null) {
                      AppSnackbar.showInfo(context, 'Please enter a time slot');
                      return;
                    }
                    context.read<CartBloc>().add(
                      CartItemAdded(
                        serviceId: service.id,
                        selectedDate: selectedDate!
                            .toIso8601String()
                            .split('T')
                            .first,
                        selectedTimeSlot:
                            '${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}',
                        quantity: quantity,
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
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
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Divider(
      thickness: 1,
      color: Theme.of(context).dividerColor.withValues(alpha: 0.4),
    );
  }
}

class _TagChip extends StatelessWidget {
  final String label;
  final IconData? icon;

  const _TagChip({required this.label, this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).dividerColor, width: 1),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[Icon(icon, size: 13), const SizedBox(width: 5)],
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}

class _PickerTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;

  const _PickerTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(color: theme.dividerColor),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label.toUpperCase(),
                    style: theme.textTheme.labelSmall?.copyWith(
                      letterSpacing: 1.8,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    value,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, size: 20),
          ],
        ),
      ),
    );
  }
}

class _QuantitySelector extends StatelessWidget {
  final int quantity;
  final VoidCallback? onDecrement;
  final VoidCallback onIncrement;

  const _QuantitySelector({
    required this.quantity,
    required this.onDecrement,
    required this.onIncrement,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: theme.dividerColor),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _QtyButton(icon: Icons.remove, onPressed: onDecrement),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              quantity.toString(),
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          _QtyButton(icon: Icons.add, onPressed: onIncrement),
        ],
      ),
    );
  }
}

class _QtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;

  const _QtyButton({required this.icon, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon),
      iconSize: 20,
      padding: const EdgeInsets.all(14),
    );
  }
}

class _BottomBar extends StatelessWidget {
  final ServiceModel service;
  final int quantity;
  final VoidCallback onAddToCart;

  const _BottomBar({
    required this.service,
    required this.quantity,
    required this.onAddToCart,
  });

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
      child: BlocConsumer<CartBloc, CartState>(
        listener: (context, state) {
          if (state is CartFailure) {
            AppSnackbar.showError(context, state.message);
          }
          if (state is CartActionSuccess) {
            AppSnackbar.showSuccess(context, state.message);
          }
        },
        builder: (context, state) {
          final isLoading = state is CartLoading;

          return Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'PRICE',
                    style: theme.textTheme.labelSmall?.copyWith(
                      letterSpacing: 2,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'LKR ${(service.price * quantity).toStringAsFixed(2)}',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),

              const SizedBox(width: 20),

              Expanded(
                child: SizedBox(
                  height: 52,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : onAddToCart,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: isLoading
                        ? const AppLoading()
                        : const Text(
                            'Add To Cart',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
