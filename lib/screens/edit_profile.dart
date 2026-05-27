import 'package:flutter/material.dart';
import 'package:memory_places_app/services/auth_service.dart';
import 'package:memory_places_app/widgets/input_field.dart';
import 'package:memory_places_app/widgets/primary_button.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() {
    return _EditProfileScreenState();
  }
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _authService = AuthService();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();

  var _isSaving = false;

  @override
  void initState() {
    super.initState();

    final user = _authService.currentUser;

    _nameController.text = user?.displayName ?? '';
    _emailController.text = user?.email ?? '';
  }

  Future<void> _saveChanges() async {
    final user = _authService.currentUser;

    if (user == null) return;

    final newName = _nameController.text.trim();
    final newEmail = _emailController.text.trim();
    final currentPassword = _currentPasswordController.text.trim();
    final newPassword = _newPasswordController.text.trim();

    final emailChanged = newEmail.isNotEmpty && newEmail != user.email;
    final passwordChanged = newPassword.isNotEmpty;
    final nameChanged = newName.isNotEmpty && newName != user.displayName;

    if (!nameChanged && !emailChanged && !passwordChanged) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('No changes to save.')));
      return;
    }

    if ((emailChanged || passwordChanged) && currentPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Current password is required to change email or password.',
          ),
        ),
      );
      return;
    }

    if (passwordChanged && newPassword.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('New password must be at least 8 characters long.'),
        ),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      await _authService.updateProfile(
        fullName: nameChanged ? newName : null,
        email: emailChanged ? newEmail : null,
        currentPassword: currentPassword,
        newPassword: passwordChanged ? newPassword : null,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully.')),
      );

      Navigator.of(context).pop();
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not update profile.')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 130,
        leadingWidth: 45,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Edit profile',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontSize: 32,
                fontFamily: 'RobotoSlab',
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              'Update your information',
              maxLines: 2,
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                fontFamily: 'RobotoSlab',
                fontSize: 20,
                fontWeight: FontWeight.w400,
                color: Color(0xFF728B25),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              InputField(
                inputText: 'Full name',
                controller: _nameController,
                requiredField: false,
              ),
              const SizedBox(height: 20),
              InputField(
                inputText: 'Email',
                controller: _emailController,
                requiredField: false,
                keyboardType: TextInputType.emailAddress,
                textCapitalization: TextCapitalization.none,
              ),
              const SizedBox(height: 20),
              InputField(
                inputText: 'Current password',
                controller: _currentPasswordController,
                requiredField: false,
                obscureText: true,
              ),
              const SizedBox(height: 30),
              InputField(
                inputText: 'New password',
                controller: _newPasswordController,
                requiredField: false,
                obscureText: true,
              ),
              const SizedBox(height: 50),
              PrimaryButton(
                btnText: _isSaving ? 'Saving...' : 'Save changes',
                onPress: _isSaving ? null : _saveChanges,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
