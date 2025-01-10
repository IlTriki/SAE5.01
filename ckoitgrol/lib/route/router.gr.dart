// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'router.dart';

/// generated route for
/// [AuthPage]
class AuthRoute extends PageRouteInfo<void> {
  const AuthRoute({List<PageRouteInfo>? children})
      : super(
          AuthRoute.name,
          initialChildren: children,
        );

  static const String name = 'AuthRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const AuthPage();
    },
  );
}

/// generated route for
/// [AuthRouterPage]
class AuthRouter extends PageRouteInfo<void> {
  const AuthRouter({List<PageRouteInfo>? children})
      : super(
          AuthRouter.name,
          initialChildren: children,
        );

  static const String name = 'AuthRouter';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const AuthRouterPage();
    },
  );
}

/// generated route for
/// [ChatPage]
class ChatRoute extends PageRouteInfo<ChatRouteArgs> {
  ChatRoute({
    Key? key,
    required UserEntity chatUser,
    required String currentUserId,
    List<PageRouteInfo>? children,
  }) : super(
          ChatRoute.name,
          args: ChatRouteArgs(
            key: key,
            chatUser: chatUser,
            currentUserId: currentUserId,
          ),
          initialChildren: children,
        );

  static const String name = 'ChatRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ChatRouteArgs>();
      return ChatPage(
        key: args.key,
        chatUser: args.chatUser,
        currentUserId: args.currentUserId,
      );
    },
  );
}

class ChatRouteArgs {
  const ChatRouteArgs({
    this.key,
    required this.chatUser,
    required this.currentUserId,
  });

  final Key? key;

  final UserEntity chatUser;

  final String currentUserId;

  @override
  String toString() {
    return 'ChatRouteArgs{key: $key, chatUser: $chatUser, currentUserId: $currentUserId}';
  }
}

/// generated route for
/// [ChatRouterPage]
class ChatRouter extends PageRouteInfo<void> {
  const ChatRouter({List<PageRouteInfo>? children})
      : super(
          ChatRouter.name,
          initialChildren: children,
        );

  static const String name = 'ChatRouter';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ChatRouterPage();
    },
  );
}

/// generated route for
/// [ChooseMethodPage]
class ChooseMethodRoute extends PageRouteInfo<void> {
  const ChooseMethodRoute({List<PageRouteInfo>? children})
      : super(
          ChooseMethodRoute.name,
          initialChildren: children,
        );

  static const String name = 'ChooseMethodRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ChooseMethodPage();
    },
  );
}

/// generated route for
/// [CreatePostPage]
class CreatePostRoute extends PageRouteInfo<void> {
  const CreatePostRoute({List<PageRouteInfo>? children})
      : super(
          CreatePostRoute.name,
          initialChildren: children,
        );

  static const String name = 'CreatePostRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const CreatePostPage();
    },
  );
}

/// generated route for
/// [ForgotPasswordPage]
class ForgotPasswordRoute extends PageRouteInfo<void> {
  const ForgotPasswordRoute({List<PageRouteInfo>? children})
      : super(
          ForgotPasswordRoute.name,
          initialChildren: children,
        );

  static const String name = 'ForgotPasswordRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ForgotPasswordPage();
    },
  );
}

/// generated route for
/// [FriendsChatPage]
class FriendsChatRoute extends PageRouteInfo<void> {
  const FriendsChatRoute({List<PageRouteInfo>? children})
      : super(
          FriendsChatRoute.name,
          initialChildren: children,
        );

  static const String name = 'FriendsChatRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const FriendsChatPage();
    },
  );
}

/// generated route for
/// [FriendsListPage]
class FriendsListRoute extends PageRouteInfo<void> {
  const FriendsListRoute({List<PageRouteInfo>? children})
      : super(
          FriendsListRoute.name,
          initialChildren: children,
        );

  static const String name = 'FriendsListRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const FriendsListPage();
    },
  );
}

/// generated route for
/// [FriendsRouterPage]
class FriendsRouter extends PageRouteInfo<void> {
  const FriendsRouter({List<PageRouteInfo>? children})
      : super(
          FriendsRouter.name,
          initialChildren: children,
        );

  static const String name = 'FriendsRouter';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const FriendsRouterPage();
    },
  );
}

/// generated route for
/// [HomePage]
class HomeRoute extends PageRouteInfo<void> {
  const HomeRoute({List<PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const HomePage();
    },
  );
}

/// generated route for
/// [LoginPage]
class LoginRoute extends PageRouteInfo<void> {
  const LoginRoute({List<PageRouteInfo>? children})
      : super(
          LoginRoute.name,
          initialChildren: children,
        );

  static const String name = 'LoginRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const LoginPage();
    },
  );
}

/// generated route for
/// [MainLayoutPage]
class MainLayoutRoute extends PageRouteInfo<void> {
  const MainLayoutRoute({List<PageRouteInfo>? children})
      : super(
          MainLayoutRoute.name,
          initialChildren: children,
        );

  static const String name = 'MainLayoutRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const MainLayoutPage();
    },
  );
}

/// generated route for
/// [PostImageMethodPage]
class PostImageMethodRoute extends PageRouteInfo<void> {
  const PostImageMethodRoute({List<PageRouteInfo>? children})
      : super(
          PostImageMethodRoute.name,
          initialChildren: children,
        );

  static const String name = 'PostImageMethodRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const PostImageMethodPage();
    },
  );
}

/// generated route for
/// [ProfilePage]
class ProfileRoute extends PageRouteInfo<void> {
  const ProfileRoute({List<PageRouteInfo>? children})
      : super(
          ProfileRoute.name,
          initialChildren: children,
        );

  static const String name = 'ProfileRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ProfilePage();
    },
  );
}

/// generated route for
/// [ProfileRouterPage]
class ProfileRouter extends PageRouteInfo<void> {
  const ProfileRouter({List<PageRouteInfo>? children})
      : super(
          ProfileRouter.name,
          initialChildren: children,
        );

  static const String name = 'ProfileRouter';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ProfileRouterPage();
    },
  );
}

/// generated route for
/// [SetPostDetailsPage]
class SetPostDetailsRoute extends PageRouteInfo<void> {
  const SetPostDetailsRoute({List<PageRouteInfo>? children})
      : super(
          SetPostDetailsRoute.name,
          initialChildren: children,
        );

  static const String name = 'SetPostDetailsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SetPostDetailsPage();
    },
  );
}

/// generated route for
/// [SettingsRouterPage]
class SettingsRouter extends PageRouteInfo<void> {
  const SettingsRouter({List<PageRouteInfo>? children})
      : super(
          SettingsRouter.name,
          initialChildren: children,
        );

  static const String name = 'SettingsRouter';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SettingsRouterPage();
    },
  );
}

/// generated route for
/// [SignupPage]
class SignupRoute extends PageRouteInfo<void> {
  const SignupRoute({List<PageRouteInfo>? children})
      : super(
          SignupRoute.name,
          initialChildren: children,
        );

  static const String name = 'SignupRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SignupPage();
    },
  );
}
