import 'package:ckoitgrol/entities/user_entity.dart';
import 'package:ckoitgrol/entities/user_post_entity.dart';
import 'package:ckoitgrol/provider/posts_provider.dart';
import 'package:ckoitgrol/provider/user_data_provider.dart';
import 'package:ckoitgrol/services/firebase/fireauth_service.dart';
import 'package:ckoitgrol/utils/button/custom_button.dart';
import 'package:ckoitgrol/utils/post/post_set_details.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:ckoitgrol/services/post/create_post_service.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

@RoutePage()
class SetPostDetailsPage extends StatefulWidget {
  const SetPostDetailsPage({super.key});

  @override
  State<SetPostDetailsPage> createState() => _SetPostDetailsPageState();
}

class _SetPostDetailsPageState extends State<SetPostDetailsPage> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(
      text: context.read<CreatePostService>().title,
    );
    descriptionController = TextEditingController(
      text: context.read<CreatePostService>().description,
    );

    // Add listeners to update the service
    titleController.addListener(() {
      context.read<CreatePostService>().setTitle(titleController.text);
    });

    descriptionController.addListener(() {
      context
          .read<CreatePostService>()
          .setDescription(descriptionController.text);
    });

    _loadUserData().then((_) {
      if (mounted) {
        setDefaultValues();
      }
    }).whenComplete(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    final userId = context.read<AuthService>().currentUser?.uid;
    if (userId != null) {
      context.read<UserDataProvider>().loadUserData(userId);
    }
  }

  Future<void> setDefaultValues() async {
    final now = DateTime.now();
    UserEntity? userData = context.read<UserDataProvider>().userData;

    // check if user data is loaded, otherwise wait for it in case of lag or delay
    while (userData?.username == null || userData?.photoURL == null) {
      await Future.delayed(const Duration(milliseconds: 100));
      userData = context.read<UserDataProvider>().userData;
    }

    context.read<CreatePostService>()
      ..setDate(now.toString())
      ..setAuthor(userData?.username ?? 'Anonymous')
      ..setAuthorProfilePicture(userData?.photoURL ?? '');
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            UserPostSetDetails(
              title: titleController.text,
              description: descriptionController.text,
              image: Image.file(context.watch<CreatePostService>().imageFile!),
              grolPercentage:
                  context.watch<CreatePostService>().grolPercentage ?? 0,
              date: context.watch<CreatePostService>().date ??
                  DateTime.now().toString(),
              author: context.watch<CreatePostService>().author ?? '',
              authorProfilePicture:
                  context.watch<CreatePostService>().authorProfilePicture ?? '',
              onTitleChanged: (value) => titleController.text = value,
              onDescriptionChanged: (value) =>
                  descriptionController.text = value,
            ),
            const SizedBox(height: 20),
            Consumer<CreatePostService>(
              builder: (context, createPostService, child) {
                return CustomButton(
                  text: 'Next',
                  onPressed: checkPostDetails() ? finishPostCreation : null,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  bool checkPostDetails() {
    final service = context.watch<CreatePostService>();

    return service.title != null &&
        service.description != null &&
        service.imageFile != null &&
        service.grolPercentage != null &&
        service.date != null &&
        service.author != null &&
        service.authorProfilePicture != null;
  }

  void finishPostCreation() {
    final post = UserPostEntity(
      id: const Uuid().v4(),
      userId: context.read<UserDataProvider>().userData?.uid ?? '',
      username: context.read<CreatePostService>().author ?? '',
      title: context.read<CreatePostService>().title ?? '',
      text: context.read<CreatePostService>().description ?? '',
      imageUrl: context.read<CreatePostService>().imageFile?.path ?? '',
      grolPercentage: context.read<CreatePostService>().grolPercentage ?? 0,
      timestamp: DateTime.now(),
    );

    // Assuming you have a File stored in CreatePostService
    final imageFile = context.read<CreatePostService>().imageFile;

    if (imageFile != null) {
      context.read<PostsProvider>().addPost(post, imageFile);
      context.router.popUntilRoot();
    } else {
      // Handle the case where the image file is null
      print("Image file is not available");
    }
  }
}
