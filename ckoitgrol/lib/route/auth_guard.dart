import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:ckoitgrol/services/firebase/fireauth_service.dart';

import 'routes.dart';
import 'router.dart';

class AuthGuard extends AutoRouteGuard with WidgetsBindingObserver {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    final authService = AuthService();
    final bool isAuthenticated = authService.currentUser != null;
    print('isAuthenticated: $isAuthenticated');
    if (isAuthenticated) {
      // If authenticated and on the Login page, redirect to MainLayout
      if (resolver.route.name == Routes.auth ||
          resolver.route.name == Routes.login ||
          resolver.route.name == Routes.register ||
          resolver.route.name == Routes.forgotPassword) {
        router.push(const MainLayoutRoute());
      }
      // Continue navigation
      resolver.next(true);
    } else {
      // Not authenticated, navigate to AuthRouter
      router.replace(const AuthRouter());
    }
  }
}
