import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:go_router/go_router.dart';
import 'package:mentecart/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:mentecart/features/cart/presentation/bloc/cart_state.dart';

class AppShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const AppShell({super.key, required this.navigationShell});

  void _onTap(int index) {
    navigationShell.goBranch(
      index,

      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,

      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,

        onDestinationSelected: _onTap,

        destinations: [
          const NavigationDestination(icon: Icon(Icons.home), label: 'Home'),

          const NavigationDestination(
            icon: Icon(Icons.receipt_long),

            label: 'Bookings',
          ),

          NavigationDestination(
            icon: BlocBuilder<CartBloc, CartState>(
              builder: (context, state) {
                int count = 0;

                if (state is CartLoaded) {
                  count = state.cart.totalItems;
                }

                return Badge(
                  isLabelVisible: count > 0,

                  label: Text(count.toString()),

                  child: const Icon(Icons.shopping_cart),
                );
              },
            ),

            label: 'Cart',
          ),

          const NavigationDestination(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
