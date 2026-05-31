import 'package:flutter/material.dart';
import 'package:memory_places_app/services/auth_service.dart';
import 'package:memory_places_app/widgets/input_field.dart';
import 'package:memory_places_app/widgets/primary_button.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  final _authService = AuthService();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  bool _isLoading = false;

  Future<void> _resetPassword() async {
    try {
      setState(() {
        _isLoading = true;
      });

      await _authService.resetPassword(_emailController.text.trim());

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password reset email sent.')),
      );

      Navigator.of(context).pop();
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.toString())));
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
              btnText: 'Send Reset Link',
              onPress: _isLoading ? () {} : _resetPassword,
            ),
          ],
        ),
      ),
    );
  }
}
