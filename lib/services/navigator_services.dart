import 'package:comments_viewer_application/screens/homepage_screen.dart';
import 'package:comments_viewer_application/screens/login_screen.dart';
import 'package:comments_viewer_application/screens/sign_up_screen.dart';
import 'package:flutter/material.dart';

class NavigatorServices {
  final GlobalKey<NavigatorState> _navigatorState = GlobalKey<NavigatorState>();

  final Map<String, Widget Function(BuildContext)> _routes = {
    '/login': (context) => const LoginScreen(),
    '/home': (context) =>  HomepageScreen(),
    '/sign-up': (context) => const SignUpScreen(),
  };

  GlobalKey<NavigatorState> get navigatorState {
    return _navigatorState;
  }

  Map<String, Widget Function(BuildContext)> get routes {
    return _routes;
  }

  NavigatorServices();

  void pushNamed(String routeName) {
    _navigatorState.currentState?.pushNamed(routeName);
  }

  void pushReplacementNamed(String routeName) {
    _navigatorState.currentState?.pushReplacementNamed(routeName);
  }

  void goBack() {
    _navigatorState.currentState?.pop();
  }
}
