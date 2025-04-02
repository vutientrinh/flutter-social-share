import 'package:flutter_social_share/modules/home_screen/home_page.dart';
import 'package:flutter_social_share/route/route_constants.dart';

import 'screen_export.dart';
import 'package:flutter/material.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case homeScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const HomePage(),
      );
    case logInScreenRoute:
      return MaterialPageRoute(builder: (context) => const LoginScreen());
    case registerScreenRoute:
      return MaterialPageRoute(builder: (context) => const RegisterScreen());

    case profileScreenRoute:
      return MaterialPageRoute(builder: (context)=>const ProfileScreen(followerName: "followerName"));
    case chatScreenRoute:
      return MaterialPageRoute(builder: (context)=> const MessagesScreen());
    default:
      return MaterialPageRoute(
        builder: (context) => const Scaffold(
          body: Center(child: Text("Page Not Found")),
        ),
      );
  }
}
