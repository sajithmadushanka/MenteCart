import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mentecart/core/widgets/app_loading.dart';
import 'package:mentecart/core/widgets/app_snackbar.dart';

import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _nameController = TextEditingController();

  final _emailController = TextEditingController();

  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Signup')),

      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthFailure) {
            AppSnackbar.showError(context, state.message);
          }
        },

        child: Padding(
          padding: const EdgeInsets.all(16),

          child: Column(
            children: [
              TextField(
                controller: _nameController,

                decoration: const InputDecoration(labelText: 'Name'),
              ),

              const SizedBox(height: 16),

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
                                SignupRequested(
                                  name: _nameController.text.trim(),

                                  email: _emailController.text.trim(),

                                  password: _passwordController.text.trim(),
                                ),
                              );
                            },

                      child: isLoading
                          ? const AppLoading()
                          : const Text('Signup'),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
