import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:go_router/go_router.dart';
import 'package:mentecart/core/widgets/app_loading.dart';

import '../../../auth/presentation/bloc/auth_bloc.dart';

import '../../../auth/presentation/bloc/auth_event.dart';

import '../../../auth/presentation/bloc/auth_state.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),

      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthLoading) {
            return const Center(child: AppLoading());
          }

          if (state is AuthAuthenticated) {
            final user = state.user;

            return ListView(
              padding: const EdgeInsets.all(24),

              children: [
                const CircleAvatar(
                  radius: 50,

                  child: Icon(Icons.person, size: 50),
                ),

                const SizedBox(height: 24),

                Center(
                  child: Text(
                    user.name,

                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),

                const SizedBox(height: 8),

                Center(
                  child: Text(
                    user.email,

                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                ),

                const SizedBox(height: 40),

                Card(
                  child: ListTile(
                    leading: const Icon(Icons.email),

                    title: const Text('Email'),

                    subtitle: Text(user.email),
                  ),
                ),

                const SizedBox(height: 12),

                Card(
                  child: ListTile(
                    leading: const Icon(Icons.verified_user),

                    title: const Text('Role'),

                    subtitle: Text(user.role),
                  ),
                ),

                const SizedBox(height: 40),

                SizedBox(
                  width: double.infinity,

                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),

                    onPressed: () async {
                      final confirmed = await showDialog<bool>(
                        context: context,

                        builder: (_) {
                          return AlertDialog(
                            title: const Text('Logout'),

                            content: const Text(
                              'Are you sure you want to logout?',
                            ),

                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context, false);
                                },

                                child: const Text('Cancel'),
                              ),

                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context, true);
                                },

                                child: const Text('Logout'),
                              ),
                            ],
                          );
                        },
                      );

                      if (confirmed == true && context.mounted) {
                        context.read<AuthBloc>().add(LogoutRequested());

                        context.go('/login');
                      }
                    },

                    icon: const Icon(Icons.logout),

                    label: const Text('Logout'),
                  ),
                ),
              ],
            );
          }

          return const Center(child: Text('User not authenticated'));
        },
      ),
    );
  }
}
