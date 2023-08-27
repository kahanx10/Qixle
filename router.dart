import 'dart:io';

import 'package:amazon_clone/common/presentation/pages/error_page.dart';
import 'package:amazon_clone/components/authentication/presentation/pages/auth_page.dart';
import 'package:amazon_clone/components/home/presentation/pages/home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppRouter {
  Route generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AuthPage.routeName:
        return platformAwarePageRoute(builder: (context) => const AuthPage());

      case HomePage.routeName:
        return platformAwarePageRoute(builder: (context) => const HomePage());

      default:
        return platformAwarePageRoute(
          builder: (context) => const ErrorPage(
            message: 'Invalid Route Name',
          ),
        );
    }
  }

  PageRoute platformAwarePageRoute(
      {required Widget Function(BuildContext) builder}) {
    if (Platform.isIOS) {
      return CupertinoPageRoute(builder: builder);
    } else {
      return MaterialPageRoute(builder: builder);
    }
  }
}
