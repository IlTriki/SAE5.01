import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:ckoitgrol/provider/auth_provider.dart';
import 'package:ckoitgrol/provider/posts_provider.dart';
import 'package:ckoitgrol/provider/user_data_provider.dart';
import 'package:ckoitgrol/provider/common_provider.dart';
import 'package:ckoitgrol/entities/user_entity.dart';
import 'package:ckoitgrol/services/firebase/fireauth_service.dart';
import 'package:ckoitgrol/utils/button/custom_button.dart';
import 'package:ckoitgrol/utils/post/post.dart';
import 'package:ckoitgrol/utils/post/post_placeholder.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

@RoutePage()
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final user = AuthService().currentUser;
  File? _selectedImage;

  Future<void> openImagePicker({bool fromProfile = false}) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 200,
      maxHeight: 200,
      imageQuality: 80,
    );

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });

      if (fromProfile) {
        saveImageToFirebase(_selectedImage!);
      }
    }
  }

  saveImageToFirebase(File image) async {
    // Upload image to Firebase Storage
    final storageRef = FirebaseStorage.instance
        .ref()
        .child('user_images')
        .child(user?.uid ?? '')
        .child('profile_picture.jpg');

    try {
      // Upload the file
      await storageRef.putFile(_selectedImage!);

      // Get the download URL
      final downloadUrl = await storageRef.getDownloadURL();

      // Update user data with the Firebase Storage URL
      final userData =
          Provider.of<UserDataProvider>(context, listen: false).userData;
      context.read<UserDataProvider>().updateUserData(UserEntity(
            uid: user?.uid ?? '',
            photoURL: downloadUrl, // Use the Firebase Storage URL
            username: userData?.username,
            bio: userData?.bio,
            location: userData?.location,
            followers: userData?.followers,
            following: userData?.following,
            posts: userData?.posts,
          ));
    } catch (e) {
      // Handle any errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error uploading image: $e',
              style: TextStyle(color: Theme.of(context).colorScheme.surface)),
          backgroundColor: Theme.of(context).colorScheme.primary,
          margin: const EdgeInsets.all(20),
          duration: const Duration(seconds: 1),
          dismissDirection: DismissDirection.down,
          padding: const EdgeInsets.all(8),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(
              color: Theme.of(context).colorScheme.primary,
              style: BorderStyle.solid,
            ),
          ),
        ),
      );
    }
  }

  Future<void> _loadPosts() async {
    final userId = context.read<AuthService>().currentUser?.uid;
    if (userId != null) {
      await context.read<PostsProvider>().loadUserPosts(userId);
      // Force a rebuild after posts are loaded
      if (mounted) {
        setState(() {});
      }
    }
  }

  Future<void> _loadUserData() async {
    final userId = context.read<AuthService>().currentUser?.uid;
    if (userId != null) {
      context.read<UserDataProvider>().loadUserData(userId);
    }
  }

  Future<void> openSettings() async {
    showModalBottomSheet(
        useRootNavigator: true,
        context: context,
        builder: (BuildContext context) {
          return Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(25),
                child: _buildSettingsContent(context),
              ));
        });
  }

  Widget _buildSettingsContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          Translate.of(context).settingsTitle,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w900,
              ),
        ),
        const SizedBox(height: 25),
        // Theme toggle
        _buildSettingsRow(
          icon: Icons.dark_mode_rounded,
          title: Translate.of(context).darkTheme,
          trailing: Switch(
            value: AdaptiveTheme.of(context).mode == AdaptiveThemeMode.dark,
            onChanged: (bool value) {
              setState(() {
                AdaptiveTheme.of(context).toggleThemeMode(useSystem: false);
              });
            },
          ),
        ),
        const SizedBox(height: 25),
        // Language toggle
        _buildLanguageRow(context),
        const SizedBox(height: 60),
        // Logout button
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: CustomButton(
            onPressed: () {
              final authProvider = context.read<AuthProvider>();
              authProvider.signOut();
            },
            text: Translate.of(context).logoutButton,
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildSettingsRow(
      {required IconData icon,
      required String title,
      required Widget trailing}) {
    return Row(
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHigh,
            shape: BoxShape.circle,
          ),
          child: Icon(icon,
              size: 20, color: Theme.of(context).colorScheme.primary),
        ),
        const SizedBox(width: 4),
        Text(title, style: Theme.of(context).textTheme.bodyLarge),
        const Spacer(),
        trailing,
      ],
    );
  }

  Widget _buildLanguageRow(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHigh,
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.language_rounded,
              size: 20, color: Theme.of(context).colorScheme.primary),
        ),
        const SizedBox(width: 4),
        Text(Translate.of(context).languageTitle,
            style: Theme.of(context).textTheme.bodyLarge),
        const Spacer(),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.arrow_left_rounded,
                  color: Theme.of(context).colorScheme.primary),
              onPressed: () => _changeLanguage(context),
            ),
            TextButton(
              child: Text(
                Translate.of(context).localeName == 'en'
                    ? Translate.of(context).english
                    : Translate.of(context).french,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              onPressed: () => _changeLanguage(context),
            ),
            IconButton(
              icon: Icon(Icons.arrow_right_rounded,
                  color: Theme.of(context).colorScheme.primary),
              onPressed: () => _changeLanguage(context),
            ),
          ],
        ),
      ],
    );
  }

  void _changeLanguage(BuildContext context) {
    final currentLocale = Translate.of(context).localeName;
    final newLocale = currentLocale == 'en' ? 'fr' : 'en';
    Provider.of<CommonProvider>(context, listen: false)
        .onChangeOfLanguage(Locale(newLocale));
  }

  void _showEditProfileSheet(BuildContext context) {
    final userData =
        Provider.of<UserDataProvider>(context, listen: false).userData;
    final _formKey = GlobalKey<FormState>();
    String? _username = userData?.username;
    String? _bio = userData?.bio;
    String? _location = userData?.location;
    String? _photoURL = userData?.photoURL;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 16,
                right: 16,
                top: 16,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      Translate.of(context).editProfileButton,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () async {
                        await openImagePicker();
                        setState(() {});
                      },
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: Theme.of(context)
                                .colorScheme
                                .surfaceContainerHigh,
                            foregroundImage: _selectedImage != null
                                ? FileImage(_selectedImage!)
                                : (userData?.photoURL != null
                                    ? NetworkImage(userData?.photoURL ?? '')
                                    : null),
                            child: const Icon(Icons.person, size: 50),
                          ),
                          const Positioned(
                            bottom: 0,
                            right: 0,
                            child: Icon(Icons.camera_alt, size: 20),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      initialValue: _username,
                      decoration: InputDecoration(
                        labelText: Translate.of(context).usernameHint,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onSaved: (value) => _username = value,
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                        controller: TextEditingController(text: _bio),
                        maxLength: 100,
                        decoration: InputDecoration(
                          labelText: Translate.of(context).bioHint,
                          border: InputBorder.none,
                          counterText: '',
                        ),
                        maxLines: 3,
                        onChanged: (value) => _bio = value,
                        onEditingComplete: () => _formKey.currentState?.save(),
                        onTapOutside: (event) => _formKey.currentState?.save(),
                        maxLengthEnforcement: MaxLengthEnforcement.enforced,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      initialValue: _location,
                      decoration: InputDecoration(
                        labelText: Translate.of(context).locationHint,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onSaved: (value) => _location = value,
                    ),
                    const SizedBox(height: 20),
                    CustomButton(
                      text: Translate.of(context).saveChangesButton,
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          _formKey.currentState?.save();
                          if (_selectedImage != null) {
                            saveImageToFirebase(_selectedImage!);
                          }
                          // Update user data
                          Provider.of<UserDataProvider>(context, listen: false)
                              .updateUserData(UserEntity(
                            uid: userData?.uid ?? '',
                            username: _username,
                            bio: _bio,
                            location: _location == null || _location!.isEmpty
                                ? Translate.of(context).noLocationYet
                                : _location,
                            photoURL: userData?.photoURL,
                          ));
                          setState(() {
                            _selectedImage = null;
                          });
                          Navigator.pop(context);
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        );
      },
    ).then((_) {
      setState(() {
        _selectedImage = null;
      });
    });
  }

  Future<void> _handleRefresh() async {
    await Future.wait([
      _loadPosts(),
      _loadUserData(),
    ]);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadPosts();
      _loadUserData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserDataProvider>(context).userData;

    if (userData == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return RefreshIndicator(
      onRefresh: _handleRefresh,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              alignment: Alignment.centerRight,
              color: Theme.of(context).colorScheme.surface,
              child: IconButton(
                padding: const EdgeInsets.only(right: 15),
                onPressed: openSettings,
                icon: const Icon(Icons.settings_rounded, size: 26),
              ),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () => openImagePicker(fromProfile: true),
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor:
                        Theme.of(context).colorScheme.surfaceContainerHigh,
                    foregroundImage: (userData.photoURL != null
                        ? NetworkImage(userData.photoURL ?? '')
                        : _selectedImage != null
                            ? FileImage(_selectedImage!)
                            : null),
                    child: const Icon(Icons.person, size: 50),
                  ),
                  const Positioned(
                    bottom: 0,
                    right: 0,
                    child: Icon(Icons.camera_alt, size: 20),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Text(userData.username ?? 'Anonymous',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.location_on_rounded,
                    size: 15,
                    color: Theme.of(context).colorScheme.surfaceContainerHigh),
                Text(userData.location ?? Translate.of(context).noLocationYet,
                    style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
            bioCard(context, userData),
            informationRow(context, userData),
            editProfileButton(context),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(Translate.of(context).yourPosts,
                    style: Theme.of(context).textTheme.bodyLarge),
              ),
            ),
            Divider(
              color: Theme.of(context).colorScheme.surfaceContainerHigh,
            ),
            userPosts(context, userData),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget bioCard(BuildContext context, UserEntity? userData) {
    return Card(
      margin: const EdgeInsets.all(15),
      child: Container(
        padding: const EdgeInsets.all(15),
        width: double.infinity,
        constraints: const BoxConstraints(minHeight: 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(userData?.bio ?? Translate.of(context).noBioYet),
          ],
        ),
      ),
    );
  }

  Widget informationRow(BuildContext context, UserEntity? userData) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(child: followersCard(context, userData)),
          Expanded(child: followingCard(context, userData)),
          Expanded(child: postsCard(context, userData)),
        ],
      ),
    );
  }

  Widget followersCard(BuildContext context, UserEntity? userData) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(15),
        child: Text(
            '${userData?.followersCount ?? 0} ${Translate.of(context).followers}'),
      ),
    );
  }

  Widget followingCard(BuildContext context, UserEntity? userData) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(15),
        child: Text(
            '${userData?.followingCount ?? 0} ${Translate.of(context).following}'),
      ),
    );
  }

  Widget postsCard(BuildContext context, UserEntity? userData) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(15),
        child:
            Text('${userData?.postsCount ?? 0} ${Translate.of(context).posts}'),
      ),
    );
  }

  Widget editProfileButton(BuildContext context) {
    return CustomButton(
      text: Translate.of(context).editProfileButton,
      onPressed: () {
        _showEditProfileSheet(context);
      },
    );
  }

  Widget userPosts(BuildContext context, UserEntity? userData) {
    final postsProvider = context.watch<PostsProvider>();

    if (postsProvider.isLoadingUserPosts) {
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 3,
        itemBuilder: (context, index) {
          return const PostPlaceholder();
        },
      );
    }

    if (postsProvider.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              postsProvider.error!,
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
            TextButton(
              onPressed: _loadPosts,
              child: Text(Translate.of(context).retry),
            ),
          ],
        ),
      );
    }

    if (postsProvider.userPosts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.post_add,
              size: 48,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              Translate.of(context).noPosts,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: postsProvider.userPosts.length,
      itemBuilder: (context, index) {
        final post = postsProvider.userPosts[index];
        return UserPost(
          id: post.id,
          likes: post.likes,
          currentUserId: context.read<AuthService>().currentUser?.uid ?? '',
          authorProfilePicture: userData?.photoURL ?? '',
          title: post.title,
          description: post.text,
          image: post.imageUrl,
          grolPercentage: post.grolPercentage,
          date: post.timestamp.toString(),
          author: post.username,
        );
      },
    );
  }
}
