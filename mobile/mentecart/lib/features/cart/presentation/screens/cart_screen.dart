import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mentecart/core/widgets/app_loading.dart';
import 'package:mentecart/core/widgets/empty_state.dart';

import '../bloc/cart_bloc.dart';
import '../bloc/cart_event.dart';
import '../bloc/cart_state.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Cart')),

      body: BlocConsumer<CartBloc, CartState>(
        listener: (context, state) {
          if (state is CartActionSuccess) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          } else if (state is CartActionFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red.shade700,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is CartLoading) {
            return const Center(child: AppLoading());
          }

          if (state is CartFailure) {
            return Center(child: Text(state.message));
          }

          if (state is CartLoaded) {
            final cart = state.cart;

            if (cart.items.isEmpty) {
              if (cart.items.isEmpty) {
                return EmptyState(
                  icon: Icons.shopping_cart_outlined,

                  title: 'Your cart is empty',

                  subtitle: 'Browse services and add items to your cart.',

                  buttonText: 'Browse Services',

                  onPressed: () {
                    context.go('/');
                  },
                );
              }
            }

            return Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),

                    itemCount: cart.items.length,

                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 16),

                    itemBuilder: (context, index) {
                      final item = cart.items[index];

                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),

                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),

                                child: Image.network(
                                  item.imageUrl,

                                  width: 90,

                                  height: 90,

                                  fit: BoxFit.cover,

                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      width: 90,

                                      height: 90,

                                      color: Colors.grey.shade300,

                                      child: const Icon(Icons.image),
                                    );
                                  },
                                ),
                              ),

                              const SizedBox(width: 16),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,

                                  children: [
                                    Text(
                                      item.title,

                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleMedium,
                                    ),

                                    const SizedBox(height: 8),

                                    Text('Date: ${item.selectedDate}'),

                                    Text('Time: ${item.selectedTimeSlot}'),

                                    Row(
                                      children: [
                                        IconButton(
                                          onPressed: item.quantity <= 1
                                              ? null
                                              : () {
                                                  context.read<CartBloc>().add(
                                                    CartItemUpdated(
                                                      itemId: item.id,

                                                      quantity:
                                                          item.quantity - 1,
                                                    ),
                                                  );
                                                },

                                          icon: const Icon(
                                            Icons.remove_circle_outline,
                                          ),
                                        ),

                                        Text(
                                          item.quantity.toString(),

                                          style: const TextStyle(
                                            fontSize: 16,

                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),

                                        IconButton(
                                          onPressed: () {
                                            context.read<CartBloc>().add(
                                              CartItemUpdated(
                                                itemId: item.id,

                                                quantity: item.quantity + 1,
                                              ),
                                            );
                                          },

                                          icon: const Icon(
                                            Icons.add_circle_outline,
                                          ),
                                        ),
                                      ],
                                    ),

                                    const SizedBox(height: 8),

                                    Text(
                                      'LKR ${item.subtotal.toStringAsFixed(2)}',

                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              IconButton(
                                onPressed: () {
                                  context.read<CartBloc>().add(
                                    CartItemRemoved(item.id),
                                  );
                                },

                                icon: const Icon(Icons.delete),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                Container(
                  padding: const EdgeInsets.all(16),

                  decoration: BoxDecoration(
                    color: Colors.white,

                    boxShadow: [
                      BoxShadow(blurRadius: 8, color: Colors.black12),
                    ],
                  ),

                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                        children: [
                          const Text('Total Items'),

                          Text(cart.totalItems.toString()),
                        ],
                      ),

                      const SizedBox(height: 8),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                        children: [
                          const Text('Total Amount'),

                          Text(
                            'LKR ${cart.totalAmount.toStringAsFixed(2)}',

                            style: const TextStyle(
                              fontWeight: FontWeight.bold,

                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      SizedBox(
                        width: double.infinity,

                        child: ElevatedButton(
                          onPressed: () {
                            context.push('/checkout');
                          },

                          child: const Text('Proceed To Checkout'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
