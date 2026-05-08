import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mentecart/app/theme/app_theme.dart';
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

import 'package:go_router/go_router.dart';
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
          ),
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

      child: const AppView(),
    );
  }
}

class AppView extends StatefulWidget {
  const AppView({super.key});

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _router = AppRouter.createRouter(context.read<AuthBloc>());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          context.read<CartBloc>().add(CartFetched());
        } else if (state is AuthInitial) {
          context.read<CartBloc>().add(CartCleared());
        }
      },
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'MenteCart',
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.system,
        routerConfig: _router,
      ),
    );
  }
}
