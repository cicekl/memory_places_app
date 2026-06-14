import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memory_places_app/viewmodels/auth_viewmodel.dart';
import 'package:memory_places_app/views/widgets/input_field.dart';
import 'package:memory_places_app/views/widgets/primary_button.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _resetPassword() async {
    final authViewModel = ref.read(authViewModelProvider);

    try {
      await authViewModel.resetPassword(_emailController.text.trim());

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password reset email sent.')),
      );

      Navigator.of(context).pop();
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authViewModel.error ?? 'Could not send reset email.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = ref.watch(authViewModelProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Forgot Password')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enter the email address associated with your account. '
              'We\'ll send you a password reset link so you can create a new password.',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium!.copyWith(color: const Color(0xFF728B25)),
            ),

            const SizedBox(height: 20),

            InputField(
              inputText: 'Email address',
              controller: _emailController,
            ),

            const SizedBox(height: 30),

            PrimaryButton(
              btnText: authViewModel.loading ? 'Sending...' : 'Send Reset Link',
              onPress: authViewModel.loading ? () {} : _resetPassword,
            ),
          ],
        ),
      ),
    );
  }
}
