import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mentecart/features/auth/presentation/screens/splash_screen.dart';
import 'package:mentecart/features/cart/repositories/cart_repository_impl.dart';
import 'package:mentecart/features/services/data/datasources/services_remote_datasource.dart';
import 'package:mentecart/features/services/presentation/bloc/services_bloc.dart';
import 'package:mentecart/features/services/presentation/bloc/services_event.dart';
import 'package:mentecart/features/services/repositories/services_repository_impl.dart';

import '../features/auth/data/datasources/auth_remote_datasource.dart';

import '../features/auth/data/repositories/auth_repository_impl.dart';

import '../features/auth/presentation/bloc/auth_bloc.dart';

import '../features/auth/presentation/bloc/auth_event.dart';

import '../features/auth/presentation/bloc/auth_state.dart';

import '../features/cart/data/datasources/cart_remote_datasource.dart';

import '../features/cart/presentation/bloc/cart_bloc.dart';

import '../features/cart/presentation/bloc/cart_event.dart';

import 'network/api_client.dart';

import 'router/app_router.dart';

import 'services/secure_storage_service.dart';

class MenteCartApp extends StatelessWidget {
  const MenteCartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AuthBloc(
            authRepository: AuthRepositoryImpl(
              remoteDatasource: AuthRemoteDatasource(apiClient: ApiClient()),
            ),

            secureStorageService: SecureStorageService(),
          )..add(AuthCheckRequested()),
        ),

        BlocProvider(
          create: (_) => CartBloc(
            cartRepository: CartRepositoryImpl(
              remoteDatasource: CartRemoteDatasource(apiClient: ApiClient()),
            ),
          )..add(CartFetched()),
        ),

        BlocProvider(
          create: (_) => ServicesBloc(
            servicesRepository: ServicesRepositoryImpl(
              remoteDatasource: ServicesRemoteDatasource(
                apiClient: ApiClient(),
              ),
            ),
          )..add(ServicesFetched()),
        ),
      ],

      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthChecking) {
            return const MaterialApp(
              debugShowCheckedModeBanner: false,

              home: SplashScreen(),
            );
          }

          final isAuthenticated = state is AuthAuthenticated;

          final router = AppRouter.router(isAuthenticated: isAuthenticated);

          return MaterialApp.router(
            debugShowCheckedModeBanner: false,

            title: 'MenteCart',

            theme: ThemeData(useMaterial3: true),

            routerConfig: router,
          );
        },
      ),
    );
  }
}
