import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:ckoitgrol/services/post/create_post_service.dart';
import 'package:ckoitgrol/utils/recognition/run_model_by_camera.dart';
import 'package:ckoitgrol/utils/recognition/run_model_by_image_picker_camera.dart';
import 'package:ckoitgrol/utils/recognition/run_model_by_image.dart';
import 'package:provider/provider.dart';

@RoutePage()
class PostImageMethodPage extends StatefulWidget {
  const PostImageMethodPage({super.key});

  @override
  State<PostImageMethodPage> createState() => _PostImageMethodPageState();
}

class _PostImageMethodPageState extends State<PostImageMethodPage> {
  @override
  Widget build(BuildContext context) {
    final imageMethod = context.watch<CreatePostService>().imageMethod;

    switch (imageMethod) {
      case 1:
        return const RunModelByCamera();
      case 2:
        return const RunModelByImageCamera();
      case 3:
        return const RunModelByImage();
      default:
        return const SizedBox.shrink();
    }
  }
}
