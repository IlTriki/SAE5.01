import 'package:ckoitgrol/route/router.dart';
import 'package:ckoitgrol/route/routes.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:ckoitgrol/services/post/create_post_service.dart';
import 'package:provider/provider.dart';

@RoutePage()
class CreatePostPage extends StatefulWidget {
  const CreatePostPage({super.key});

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter.pageView(
      routes: const [
        ChooseMethodRoute(),
        PostImageMethodRoute(),
        SetPostDetailsRoute(),
      ],
      physics: const NeverScrollableScrollPhysics(),
      builder: (context, child, _) {
        return ColorfulSafeArea(
          color: Routes.isCreatePostRoute(context.routeData.route.fullPath)
              ? const Color(0xff000000)
              : Theme.of(context).colorScheme.surface,
          child: Scaffold(
            backgroundColor:
                Routes.isCreatePostRoute(context.routeData.route.fullPath)
                    ? const Color(0xff000000)
                    : Theme.of(context).colorScheme.surface,
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_rounded,
                  color:
                      Routes.isCreatePostRoute(context.routeData.route.fullPath)
                          ? const Color(0xfffff7fa)
                          : Theme.of(context).colorScheme.onSurface,
                ),
                onPressed: () {
                  context.read<CreatePostService>().reset();
                  Navigator.of(context).pop(false);
                },
              ),
              backgroundColor:
                  Routes.isCreatePostRoute(context.routeData.route.fullPath)
                      ? const Color(0xff000000)
                      : Theme.of(context).colorScheme.surface,
            ),
            body: child,
          ),
        );
      },
    );
  }
}
