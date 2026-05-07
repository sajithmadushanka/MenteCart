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

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 280,

                pinned: true,

                flexibleSpace: FlexibleSpaceBar(
                  title: Text(service.title),

                  background: Image.network(
                    service.imageUrl,

                    fit: BoxFit.cover,

                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey.shade300,

                        child: const Center(child: Icon(Icons.image, size: 72)),
                      );
                    },
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Text(
                        service.title,

                        style: Theme.of(context).textTheme.headlineSmall,
                      ),

                      const SizedBox(height: 12),

                      Row(
                        children: [
                          Chip(label: Text(service.category)),

                          const SizedBox(width: 12),

                          Chip(label: Text('${service.duration} mins')),
                        ],
                      ),

                      const SizedBox(height: 24),

                      Text(
                        service.description,

                        style: Theme.of(context).textTheme.bodyLarge,
                      ),

                      const SizedBox(height: 32),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                        children: [
                          Text(
                            'Price',

                            style: Theme.of(context).textTheme.titleMedium,
                          ),

                          Text(
                            'LKR ${service.price.toStringAsFixed(2)}',

                            style: const TextStyle(
                              fontSize: 24,

                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          Text(
                            'Booking Details',

                            style: Theme.of(context).textTheme.titleLarge,
                          ),

                          const SizedBox(height: 16),

                          SizedBox(
                            width: double.infinity,

                            child: OutlinedButton(
                              onPressed: pickDate,

                              child: Text(
                                selectedDate == null
                                    ? 'Select Date'
                                    : selectedDate!
                                          .toIso8601String()
                                          .split('T')
                                          .first,
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          SizedBox(
                            width: double.infinity,

                            child: OutlinedButton(
                              onPressed: pickTime,

                              child: Text(
                                selectedTime == null
                                    ? 'Select Time Slot'
                                    : selectedTime!.format(context),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          Row(
                            children: [
                              const Text('Quantity'),

                              const SizedBox(width: 16),

                              IconButton(
                                onPressed: quantity > 1
                                    ? () {
                                        setState(() {
                                          quantity--;
                                        });
                                      }
                                    : null,

                                icon: const Icon(Icons.remove),
                              ),

                              Text(quantity.toString()),

                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    quantity++;
                                  });
                                },

                                icon: const Icon(Icons.add),
                              ),
                            ],
                          ),

                          const SizedBox(height: 24),

                          BlocConsumer<CartBloc, CartState>(
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

                              return SizedBox(
                                width: double.infinity,

                                child: ElevatedButton(
                                  onPressed: isLoading
                                      ? null
                                      : () {
                                          if (selectedDate == null) {
                                            AppSnackbar.showInfo(
                                              context,
                                              'Please select a date',
                                            );

                                            return;
                                          }

                                          if (selectedTime == null) {
                                            AppSnackbar.showInfo(
                                              context,
                                              'Please enter a time slot',
                                            );

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

                                  child: isLoading
                                      ? const AppLoading()
                                      : const Text('Add To Cart'),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
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
