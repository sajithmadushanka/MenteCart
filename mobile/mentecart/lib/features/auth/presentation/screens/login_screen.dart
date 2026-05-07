import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mentecart/core/widgets/app_loading.dart';
import 'package:mentecart/core/widgets/app_snackbar.dart';
import 'package:mentecart/features/auth/presentation/screens/signup_screen.dart';

import '../../../../app/network/api_client.dart';
import '../../../../app/services/secure_storage_service.dart';

import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';

import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();

  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),

      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthFailure) {
            AppSnackbar.showError(context, state.message);
          }

          if (state is AuthAuthenticated) {
            AppSnackbar.showSuccess(context, 'Login successful');
          }
        },

        child: Padding(
          padding: const EdgeInsets.all(16),

          child: Column(
            children: [
              TextField(
                controller: _emailController,

                decoration: const InputDecoration(labelText: 'Email'),
              ),

              const SizedBox(height: 16),

              TextField(
                controller: _passwordController,

                obscureText: true,

                decoration: const InputDecoration(labelText: 'Password'),
              ),

              const SizedBox(height: 24),

              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  final isLoading = state is AuthLoading;

                  return SizedBox(
                    width: double.infinity,

                    child: ElevatedButton(
                      onPressed: isLoading
                          ? null
                          : () {
                              context.read<AuthBloc>().add(
                                LoginRequested(
                                  email: _emailController.text.trim(),

                                  password: _passwordController.text.trim(),
                                ),
                              );
                            },

                      child: isLoading
                          ? const SizedBox(
                              height: 20,

                              width: 20,

                              child: AppLoading(),
                            )
                          : const Text('Login'),
                    ),
                  );
                },
              ),

              TextButton(
                onPressed: () {
                  context.push('/signup');
                },

                child: const Text('Create account'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
