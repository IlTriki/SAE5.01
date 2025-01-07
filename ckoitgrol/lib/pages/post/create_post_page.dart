import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:ckoitgrol/utils/recognition/run_model_by_image_picker_camera.dart';
import 'package:ckoitgrol/utils/recognition/run_model_by_image.dart';
import 'package:ckoitgrol/utils/recognition/run_model_by_camera.dart';

@RoutePage()
class CreatePostPage extends StatefulWidget {
  const CreatePostPage({super.key});

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  int? optionSelected;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded,
              color: Theme.of(context).colorScheme.primary),
          onPressed: () {
            optionSelected == null
                ? context.router.maybePop()
                : () {
                    setState(() {
                      optionSelected = null;
                    });
                  };
          },
        ),
      ),
      body: optionSelected == null
          ? optionSelector()
          : optionSelected == 1
              ? const RunModelByCamera()
              : optionSelected == 2
                  ? const RunModelByImageCamera()
                  : optionSelected == 3
                      ? const RunModelByImage()
                      : const SizedBox.shrink(),
    );
  }

  Widget optionSelector() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
      child: Column(
        children: [
          Column(
            children: [
              Text(
                'Let\'s create a grolesque post!',
                style: TextStyle(
                    fontSize: Theme.of(context).textTheme.titleLarge?.fontSize,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary),
                textAlign: TextAlign.start,
              ),
              Text(
                'First, choose how you would like to upload your image',
                style: TextStyle(
                    fontSize: Theme.of(context).textTheme.titleMedium?.fontSize,
                    color: Theme.of(context).colorScheme.secondary),
                textAlign: TextAlign.start,
              ),
            ],
          ),
          const Spacer(),
          Icon(Icons.photo_library_outlined,
              size: MediaQuery.of(context).size.width * 0.5,
              color: Theme.of(context).colorScheme.primary),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: Wrap(
              spacing: 10.0,
              runSpacing: 10.0,
              alignment: WrapAlignment.spaceBetween,
              children: [
                optionCard(context, 1, 'Real Time',
                    Icons.radio_button_checked_rounded),
                optionCard(context, 2, 'Camera', Icons.camera_alt_outlined),
                optionCard(
                    context, 3, 'From gallery', Icons.photo_library_rounded),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget optionCard(
      BuildContext context, int option, String title, IconData icon) {
    return GestureDetector(
      onTap: () {
        setState(() {
          optionSelected = option;
        });
      },
      child: Container(
        height: 100,
        width: 150,
        alignment: Alignment.center,
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon,
                color: Theme.of(context).colorScheme.primary, size: 20.0),
            const SizedBox(width: 4.0),
            Text(title,
                style: TextStyle(color: Theme.of(context).colorScheme.primary)),
          ],
        ),
      ),
    );
  }
}
