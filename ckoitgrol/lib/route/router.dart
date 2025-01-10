import 'package:auto_route/auto_route.dart';
import 'package:ckoitgrol/entities/user_entity.dart';

import 'package:ckoitgrol/pages/main_layout_page.dart';
import 'package:ckoitgrol/pages/auth/auth_page.dart';
import 'package:ckoitgrol/pages/auth/login_page.dart';
import 'package:ckoitgrol/pages/auth/signup_page.dart';
import 'package:ckoitgrol/pages/auth/forgot_password_page.dart';
import 'package:ckoitgrol/pages/home_page.dart';
import 'package:ckoitgrol/pages/friends/friends_chat_page.dart';
import 'package:ckoitgrol/pages/friends/friends_list_page.dart';
import 'package:ckoitgrol/pages/friends/chat_page.dart';
import 'package:ckoitgrol/pages/profile/profile_page.dart';
import 'package:ckoitgrol/pages/post/create_post_page.dart';
import 'package:ckoitgrol/pages/post/steps/set_post_details_page.dart';
import 'package:ckoitgrol/pages/post/steps/post_image_method_page.dart';
import 'package:ckoitgrol/pages/post/steps/choose_method_page.dart';
import 'package:flutter/material.dart';

import 'auth_guard.dart';
import 'routes.dart';
import 'auth_router.dart';
import 'friends_router.dart';
import 'profile_router.dart';
import 'settings_router.dart';
import 'chat_router.dart';

part 'router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        // Main layout
        AutoRoute(
          path: '/',
          page: MainLayoutRoute.page,
          initial: true,
          children: [
            AutoRoute(
              initial: true,
              path: Routes.home,
              page: HomeRoute.page,
            ),
            AutoRoute(
              path: Routes.friendsChat,
              page: ChatRouter.page,
              children: [
                AutoRoute(
                  initial: true,
                  path: Routes.chat,
                  page: FriendsChatRoute.page,
                ),
                AutoRoute(
                  path: Routes.chat,
                  page: ChatRoute.page,
                ),
              ],
            ),
            AutoRoute(
              path: Routes.friends,
              page: FriendsRouter.page,
              children: [
                AutoRoute(
                  initial: true,
                  path: Routes.friendsList,
                  page: FriendsListRoute.page,
                ),
              ],
            ),
            AutoRoute(
              path: Routes.profile,
              page: ProfileRouter.page,
              children: [
                AutoRoute(
                  page: ProfileRoute.page,
                  initial: true,
                ),
              ],
            ),
          ],
          guards: [AuthGuard()],
        ),
        AutoRoute(
          path: Routes.createPost,
          page: CreatePostRoute.page,
          children: [
            AutoRoute(
              path: Routes.chooseMethod,
              page: ChooseMethodRoute.page,
            ),
            AutoRoute(
              path: Routes.postImageMethod,
              page: PostImageMethodRoute.page,
            ),
            AutoRoute(
              path: Routes.setPostDetails,
              page: SetPostDetailsRoute.page,
            ),
          ],
          guards: [AuthGuard()],
        ),
        // Auth routes
        AutoRoute(
          path: '/auth',
          page: AuthRouter.page,
          children: [
            AutoRoute(
              initial: true,
              path: Routes.auth,
              page: AuthRoute.page,
            ),
            AutoRoute(
              path: Routes.login,
              page: LoginRoute.page,
            ),
            AutoRoute(
              path: Routes.register,
              page: SignupRoute.page,
            ),
            AutoRoute(
              path: Routes.forgotPassword,
              page: ForgotPasswordRoute.page,
            ),
          ],
        ),
      ];
}
