import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:go_router/go_router.dart';

import 'package:mentecart/core/widgets/app_cached_image.dart';

import 'package:mentecart/core/widgets/app_loading.dart';

import 'package:mentecart/core/widgets/empty_state.dart';

import '../bloc/services_bloc.dart';

import '../bloc/services_event.dart';

import '../bloc/services_state.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  final searchController = TextEditingController();

  String selectedCategory = '';

  final categories = [
    '',
    'cleaning',
    'plumbing',
    'tutoring',
    'beauty',
    'electrical',
    'consultation',
  ];

  @override
  void initState() {
    super.initState();

    fetchServices();
  }

  void fetchServices() {
    context.read<ServicesBloc>().add(
      ServicesFetched(
        search: searchController.text,

        category: selectedCategory,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Services')),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),

            child: Column(
              children: [
                TextField(
                  controller: searchController,

                  decoration: InputDecoration(
                    hintText: 'Search services',

                    prefixIcon: const Icon(Icons.search),

                    suffixIcon: searchController.text.isNotEmpty
                        ? IconButton(
                            onPressed: () {
                              searchController.clear();

                              fetchServices();

                              setState(() {});
                            },

                            icon: const Icon(Icons.close),
                          )
                        : null,

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),

                  textInputAction: TextInputAction.search,

                  onChanged: (_) {
                    setState(() {});
                  },

                  onSubmitted: (_) {
                    fetchServices();
                  },
                ),

                const SizedBox(height: 16),

                SizedBox(
                  height: 45,

                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,

                    itemBuilder: (context, index) {
                      final category = categories[index];

                      final isSelected = selectedCategory == category;

                      return ChoiceChip(
                        label: Text(category.isEmpty ? 'All' : category),

                        selected: isSelected,

                        onSelected: (_) {
                          setState(() {
                            selectedCategory = category;
                          });

                          fetchServices();
                        },
                      );
                    },

                    separatorBuilder: (_, _) => const SizedBox(width: 8),

                    itemCount: categories.length,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: BlocBuilder<ServicesBloc, ServicesState>(
              builder: (context, state) {
                if (state is ServicesLoading) {
                  return const AppLoading();
                }

                if (state is ServicesFailure) {
                  return EmptyState(
                    icon: Icons.error_outline,

                    title: 'Failed to load services',

                    subtitle: state.message,

                    buttonText: 'Retry',

                    onPressed: () {
                      fetchServices();
                    },
                  );
                }

                if (state is ServicesLoaded) {
                  if (state.services.isEmpty) {
                    return EmptyState(
                      icon: Icons.home_repair_service,

                      title: 'No services found',

                      subtitle: 'Try a different search or category.',
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () async {
                      fetchServices();
                    },

                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,

                        vertical: 8,
                      ),

                      itemCount: state.services.length,

                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 16),

                      itemBuilder: (context, index) {
                        final service = state.services[index];

                        return GestureDetector(
                          onTap: () {
                            context.push('/services/${service.id}');
                          },

                          child: Card(
                            elevation: 2,

                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),

                            child: Padding(
                              padding: const EdgeInsets.all(16),

                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,

                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(14),

                                    child: AppCachedImage(
                                      imageUrl: service.imageUrl,

                                      height: 190,

                                      width: double.infinity,
                                    ),
                                  ),

                                  const SizedBox(height: 16),

                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,

                                    children: [
                                      Expanded(
                                        child: Text(
                                          service.title,

                                          style: Theme.of(
                                            context,
                                          ).textTheme.headlineSmall,

                                          maxLines: 1,

                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),

                                      Chip(label: Text(service.category)),
                                    ],
                                  ),

                                  const SizedBox(height: 8),

                                  Text(
                                    service.description,

                                    maxLines: 2,

                                    overflow: TextOverflow.ellipsis,

                                    style: TextStyle(
                                      color: Colors.grey.shade700,
                                    ),
                                  ),

                                  const SizedBox(height: 18),

                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,

                                    children: [
                                      Text(
                                        'LKR ${service.price.toStringAsFixed(2)}',

                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,

                                          fontSize: 20,
                                        ),
                                      ),

                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.access_time,

                                            size: 18,
                                          ),

                                          const SizedBox(width: 6),

                                          Text('${service.duration} mins'),
                                        ],
                                      ),
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
        ],
      ),
    );
  }
}
