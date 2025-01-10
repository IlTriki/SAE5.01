class Routes {
  static const String home = 'home';
  static const String createPost = '/create-post';
  static const String chooseMethod = 'choose-method';
  static const String postImageMethod = 'post-image-method';
  static const String setPostDetails = 'set-post-details';
  static const String friends = 'friends';
  static const String friendsList = 'list';
  static const String friendsChat = 'friends-chat';
  static const String chat = 'chat';
  static const String profile = 'profile';
  static const String auth = 'main';
  static const String login = 'login';
  static const String register = 'register';
  static const String forgotPassword = 'forgot-password';
  static const String resetPassword = 'reset-password';

  static const List<String> createPostRoutes = [
    '$createPost/$chooseMethod',
    '$createPost/$postImageMethod',
  ];

  static bool isCreatePostRoute(String route) {
    return createPostRoutes.contains(route);
  }
}
