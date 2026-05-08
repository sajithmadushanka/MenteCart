import 'dart:async';

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
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/bloc/auth_state.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  static GoRouter createRouter(AuthBloc authBloc) {
    return GoRouter(
      navigatorKey: rootNavigatorKey,
      initialLocation: '/',
      refreshListenable: GoRouterRefreshStream(authBloc.stream),

      redirect: (context, state) {
        final authState = authBloc.state;

        if (authState is AuthChecking) {
          return '/splash';
        }

        final isAuthenticated = authState is AuthAuthenticated;
        final isAuthRoute =
            state.matchedLocation == '/login' ||
            state.matchedLocation == '/signup';
        final isSplashRoute = state.matchedLocation == '/splash';

        if (!isAuthenticated && !isAuthRoute) {
          return '/login';
        }

        if (isAuthenticated && (isAuthRoute || isSplashRoute)) {
          return '/';
        }

        return null;
      },

      routes: [
        GoRoute(
          path: '/splash',
          builder: (context, state) => const SplashScreen(),
        ),

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

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
      (dynamic _) => notifyListeners(),
    );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
