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
      body: Column(
        children: [
          _SearchHeader(
            searchController: searchController,
            categories: categories,
            selectedCategory: selectedCategory,
            onSearch: () {
              fetchServices();
              setState(() {});
            },
            onClear: () {
              searchController.clear();
              fetchServices();
              setState(() {});
            },
            onCategorySelected: (category) {
              setState(() => selectedCategory = category);
              fetchServices();
            },
            onChanged: (_) => setState(() {}),
          ),

          Expanded(
            child: BlocBuilder<ServicesBloc, ServicesState>(
              builder: (context, state) {
                if (state is ServicesLoading) {
                  return const Center(child: AppLoading());
                }

                if (state is ServicesFailure) {
                  return EmptyState(
                    icon: Icons.error_outline,
                    title: 'Failed to load services',
                    subtitle: state.message,
                    buttonText: 'Retry',
                    onPressed: fetchServices,
                  );
                }

                if (state is ServicesLoaded) {
                  if (state.services.isEmpty) {
                    return const EmptyState(
                      icon: Icons.home_repair_service,
                      title: 'No services found',
                      subtitle: 'Try a different search or category.',
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () async => fetchServices(),
                    child: ListView.separated(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
                      itemCount: state.services.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 20),
                      itemBuilder: (context, index) {
                        final service = state.services[index];
                        return _ServiceCard(
                          service: service,
                          onTap: () => context.push('/services/${service.id}'),
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

class _SearchHeader extends StatelessWidget {
  final TextEditingController searchController;
  final List<String> categories;
  final String selectedCategory;
  final VoidCallback onSearch;
  final VoidCallback onClear;
  final ValueChanged<String> onCategorySelected;
  final ValueChanged<String> onChanged;

  const _SearchHeader({
    required this.searchController,
    required this.categories,
    required this.selectedCategory,
    required this.onSearch,
    required this.onClear,
    required this.onCategorySelected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final topPadding = MediaQuery.of(context).padding.top;

    return Container(
      padding: EdgeInsets.fromLTRB(20, topPadding + 20, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Services',
            style: theme.textTheme.headlineLarge?.copyWith(
              fontWeight: FontWeight.w800,
              letterSpacing: -1,
              height: 1,
            ),
          ),

          const SizedBox(height: 20),

          TextField(
            controller: searchController,
            decoration: InputDecoration(
              hintText: 'Search services...',
              prefixIcon: const Padding(
                padding: EdgeInsets.only(left: 4),
                child: Icon(Icons.search, size: 22),
              ),
              suffixIcon: searchController.text.isNotEmpty
                  ? IconButton(
                      onPressed: onClear,
                      icon: const Icon(Icons.close, size: 18),
                    )
                  : null,
              filled: true,
              fillColor: theme.dividerColor.withValues(alpha: 0.08),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  color: theme.colorScheme.primary,
                  width: 1.5,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
            textInputAction: TextInputAction.search,
            onChanged: onChanged,
            onSubmitted: (_) => onSearch(),
          ),

          const SizedBox(height: 14),

          SizedBox(
            height: 38,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final category = categories[index];
                final isSelected = selectedCategory == category;
                final label = category.isEmpty ? 'All' : category;

                return GestureDetector(
                  onTap: () => onCategorySelected(category),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOut,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? theme.colorScheme.primary
                          : Colors.transparent,
                      border: Border.all(
                        color: isSelected
                            ? theme.colorScheme.primary
                            : theme.dividerColor,
                        width: 1.2,
                      ),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Text(
                      label[0].toUpperCase() + label.substring(1),
                      style: theme.textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.2,
                        color: isSelected
                            ? theme.colorScheme.onPrimary
                            : theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  final dynamic service;
  final VoidCallback onTap;

  const _ServiceCard({required this.service, required this.onTap});

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                AppCachedImage(
                  imageUrl: service.imageUrl,
                  height: 200,
                  width: double.infinity,
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: _CategoryBadge(label: service.category),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    service.title,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.3,
                      height: 1.2,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 8),

                  Text(
                    service.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      height: 1.55,
                      color: theme.colorScheme.onSurface.withValues(
                        alpha: 0.55,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'PRICE',
                            style: theme.textTheme.labelSmall?.copyWith(
                              letterSpacing: 2,
                              fontWeight: FontWeight.w700,
                              color: theme.colorScheme.onSurface.withValues(
                                alpha: 0.45,
                              ),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'LKR ${service.price.toStringAsFixed(2)}',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.3,
                            ),
                          ),
                        ],
                      ),

                      Row(
                        children: [
                          Icon(
                            Icons.schedule_outlined,
                            size: 15,
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.5,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            '${service.duration} min',
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w500,
                              color: theme.colorScheme.onSurface.withValues(
                                alpha: 0.55,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryBadge extends StatelessWidget {
  final String label;

  const _CategoryBadge({required this.label});

  @override
  Widget build(BuildContext context) {


    return ClipRRect(
      borderRadius: BorderRadius.circular(100),
      child: BackdropFilter(
        filter: ColorFilter.mode(
          Colors.black.withValues(alpha: 0.15),
          BlendMode.darken,
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.35),
            borderRadius: BorderRadius.circular(100),
          ),
          child: Text(
            label[0].toUpperCase() + label.substring(1),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.4,
            ),
          ),
        ),
      ),
    );
  }
}
