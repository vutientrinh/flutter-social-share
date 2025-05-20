import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_social_share/providers/state_provider/auth_provider.dart';
import 'package:flutter_social_share/screens/authentication/update_profile.dart';
import 'package:flutter_social_share/screens/ecommerce_screen/address_screen.dart';
import 'package:flutter_social_share/screens/posts/views/saved_posts_screen.dart';

import '../../../providers/auth_token_provider.dart';
import '../../authentication/login_screen.dart';

class ShowSettingBottomSheet extends ConsumerWidget {
  const ShowSettingBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.save_outlined, color: Colors.black),
            title: const Text('Save posts'),
            onTap: () async {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const SavedPostsScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.home_work_outlined, color: Colors.black),
            title: const Text('Your address'),
            onTap: () async {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const AddressScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.edit, color: Colors.black),
            title: const Text('Edit profile'),
            onTap: () async {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const UpdateProfile()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Logout'),
            onTap: () async {
              Navigator.of(context).pop(); // close bottom sheet
              await ref.read(authTokenProvider.notifier).clearToken();
              await ref.read(authServiceProvider).logout();
              if (context.mounted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
