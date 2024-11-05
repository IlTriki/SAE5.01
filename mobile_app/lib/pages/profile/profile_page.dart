import 'package:ckoitgrol/routing/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Profile Picture
            Center(
              child: CircleAvatar(
                radius: 60,
                backgroundImage: user?.photoURL == null
                    ? NetworkImage(user!.photoURL!)
                    : null,
                backgroundColor: Theme.of(context).colorScheme.secondary,
                child: user?.photoURL != null
                    ? const Icon(Icons.person, size: 60)
                    : null,
              ),
            ),
            const SizedBox(height: 16),
            // Name
            Text(
              user?.displayName ?? 'Anonymous User',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).secondaryHeaderColor,
              ),
            ),
            const SizedBox(height: 8),
            // Email
            Text(
              user?.email ?? 'No email available',
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).canvasColor,
              ),
            ),
            const SizedBox(height: 24),
            // Action Buttons (Edit Profile, Settings)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to Edit Profile page or implement functionality
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                    ),
                    child: const Text(
                      'Edit Profile',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () {
                      // Navigate to Settings page or implement functionality
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                          color: Theme.of(context).colorScheme.primary),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                    ),
                    child: const Text(
                      'Settings',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Additional Info Section
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  ListTile(
                    leading: Icon(Icons.email,
                        color: Theme.of(context).iconTheme.color),
                    title: const Text('Email'),
                    subtitle: Text(user?.email ?? 'No email available'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => signOut(context),
              child: const Text('Sign Out'),
            ),
          ],
        ),
      ),
    );
  }

  void signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Get.offAllNamed(Routes.STARTING_AUTH);
  }
}
