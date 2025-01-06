import 'package:auto_route/auto_route.dart';

class RouterService {
  static final RouterService _instance = RouterService._internal();
  late StackRouter router;

  factory RouterService() {
    return _instance;
  }

  RouterService._internal();

  void setRouter(StackRouter stackRouter) {
    router = stackRouter;
  }
}
