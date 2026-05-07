import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
  final IconData icon;

  final String title;

  final String subtitle;

  final String? buttonText;

  final VoidCallback? onPressed;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.buttonText,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Icon(icon, size: 90, color: Colors.grey.shade400),

            const SizedBox(height: 24),

            Text(
              title,

              style: Theme.of(context).textTheme.headlineSmall,

              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 12),

            Text(
              subtitle,

              style: TextStyle(color: Colors.grey.shade600),

              textAlign: TextAlign.center,
            ),

            if (buttonText != null && onPressed != null) ...[
              const SizedBox(height: 32),

              ElevatedButton(onPressed: onPressed, child: Text(buttonText!)),
            ],
          ],
        ),
      ),
    );
  }
}
