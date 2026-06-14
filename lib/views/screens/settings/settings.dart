import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memory_places_app/providers/auth_provider.dart';
import 'package:memory_places_app/viewmodels/auth_viewmodel.dart';
import 'package:memory_places_app/views/screens/settings/edit_profile.dart';
import 'package:memory_places_app/views/screens/settings/help.dart';
import 'package:memory_places_app/views/screens/login.dart';
import 'package:memory_places_app/views/screens/settings/manage_categories.dart';
import 'package:memory_places_app/views/screens/settings/notifications.dart';
import 'package:memory_places_app/views/widgets/settings_option.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authViewModel = ref.watch(authViewModelProvider);
    final user = ref.watch(authProvider);

    final fullName = user?.displayName ?? 'User';
    final email = user?.email ?? 'No email';
    final initials = fullName
        .trim()
        .split(' ')
        .where((part) => part.isNotEmpty)
        .take(2)
        .map((part) => part[0].toUpperCase())
        .join();

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 130,
        leadingWidth: 45,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Settings',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontSize: 32,
                fontFamily: 'RobotoSlab',
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              'Manage your account and preferences',
              maxLines: 2,
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                fontFamily: 'RobotoSlab',
                fontSize: 20,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF728B25),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Center(
            child: Container(
              width: 365,
              height: 110,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: const Color(0xFF728B25),
                      radius: 40,
                      child: Text(
                        initials,
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontSize: 30,
                          color: const Color(0xFFF5F1E8),
                        ),
                      ),
                    ),
                    const SizedBox(width: 18),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          fullName,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(
                          email,
                          style: Theme.of(context).textTheme.titleSmall!
                              .copyWith(
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFF728B25),
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),
          SettingsOption(
            option: 'Edit profile',
            description: 'Edit your information',
            icon: Icons.person_outline,
            color: const Color(0xFF728B25),
            onPress: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const EditProfileScreen(),
                ),
              );
            },
          ),
          const SizedBox(height: 10),
          SettingsOption(
            option: 'Categories',
            description: 'Manage place types',
            icon: Icons.star_outline_outlined,
            color: const Color(0xFFF19E39),
            onPress: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const ManageCategoriesScreen(),
              ),
            ),
          ),
          const SizedBox(height: 10),
          SettingsOption(
            option: 'Notifications',
            description: 'Manage notifications',
            icon: Icons.notifications_outlined,
            color: const Color(0xFF728B25),
            onPress: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const NotificationsScreen(),
              ),
            ),
          ),
          const SizedBox(height: 10),
          SettingsOption(
            option: 'Help',
            description: 'Learn how to use the app',
            icon: Icons.help_outline,
            color: const Color(0xFFF19E39),
            onPress: () => Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (context) => const HelpScreen())),
          ),
          const SizedBox(height: 50),
          SizedBox(
            width: 368,
            height: 57,
            child: ElevatedButton(
              onPressed: () async {
                await authViewModel.logout();
                if (!context.mounted) return;
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xff4A3728),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                side: const BorderSide(color: Color(0xFF728B25)),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.logout_sharp, color: Color(0xff4A3728), size: 25),
                  SizedBox(width: 10),
                  Text('Log out', style: TextStyle(fontSize: 16)),
                ],
              ),
            ),
          ),
          const Spacer(),
          const Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: Text(
              "Memory Places v1.0.0",
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFF8A9B61)),
            ),
          ),
        ],
      ),
    );
  }
}
