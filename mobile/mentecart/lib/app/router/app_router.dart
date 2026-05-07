import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mentecart/features/bookings/presentation/screens/booking_success_screen.dart';

import '../shell/app_shell.dart';

import '../../features/auth/presentation/screens/login_screen.dart';

import '../../features/auth/presentation/screens/signup_screen.dart';

import '../../features/bookings/presentation/screens/booking_details_screen.dart';

import '../../features/bookings/presentation/screens/bookings_screen.dart';

import '../../features/bookings/presentation/screens/checkout_screen.dart';

import '../../features/cart/presentation/screens/cart_screen.dart';

import '../../features/profile/presentation/screens/profile_screen.dart';

import '../../features/services/presentation/screens/service_details_screen.dart';

import '../../features/services/presentation/screens/services_screen.dart';
  final rootNavigatorKey = GlobalKey<NavigatorState>();
  
class AppRouter {
  static GoRouter router({required bool isAuthenticated}) {
  
    return GoRouter(
      navigatorKey: rootNavigatorKey,
      initialLocation: '/',

      redirect: (context, state) {
        final isAuthRoute =
            state.matchedLocation == '/login' ||
            state.matchedLocation == '/signup';

        if (!isAuthenticated && !isAuthRoute) {
          return '/login';
        }

        if (isAuthenticated && isAuthRoute) {
          return '/';
        }

        return null;
      },

      routes: [
        GoRoute(
          path: '/login',

          builder: (context, state) => const LoginScreen(),
        ),

        GoRoute(
          path: '/signup',

          builder: (context, state) => const SignupScreen(),
        ),

        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            return AppShell(navigationShell: navigationShell);
          },

          branches: [
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/',

                  builder: (context, state) => const ServicesScreen(),

                  routes: [
                    GoRoute(
                      path: 'services/:id',

                      builder: (context, state) {
                        final id = state.pathParameters['id']!;

                        return ServiceDetailsScreen(serviceId: id);
                      },
                    ),
                  ],
                ),
              ],
            ),

            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/bookings',

                  builder: (context, state) => const BookingsScreen(),

                  routes: [
                    GoRoute(
                      path: ':id',

                      builder: (context, state) {
                        final id = state.pathParameters['id']!;

                        return BookingDetailsScreen(bookingId: id);
                      },
                    ),
                  ],
                ),
              ],
            ),

            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/cart',

                  builder: (context, state) => const CartScreen(),
                ),
              ],
            ),

            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/profile',

                  builder: (context, state) => const ProfileScreen(),
                ),
              ],
            ),
          ],
        ),

        GoRoute(
          path: '/checkout',

          builder: (context, state) => const CheckoutScreen(),
        ),

        GoRoute(
          path: '/booking-success',

          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>;

            return BookingSuccessScreen(
              bookingId: extra['bookingId'],

              bookingNumber: extra['bookingNumber'],

              paid: extra['paid'],
            );
          },
        ),
      ],
    );
  }
}
