import 'package:flutter_social_share/screens/home_screen/home_page.dart';
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
    case suggestionScreenRoute:
      return MaterialPageRoute(builder: (context) => const SuggestionUser());
    case friendScreenRoute:
      return MaterialPageRoute(builder: (context)=> const FriendList());
    case profileScreenRoute:
      return MaterialPageRoute(
          builder: (context) =>
              const ProfileScreen(followerName: "followerName"));
    case chatScreenRoute:
      return MaterialPageRoute(builder: (context) => const MessagesScreen());
    case ecommerceScreenRoute:
      return MaterialPageRoute(
          builder: (context) => const EcommerceHomeScreen());
    case createPostScreenRoute:
      return MaterialPageRoute(builder: (context) => const CreatePostScreen());
    default:
      return MaterialPageRoute(
        builder: (context) => const Scaffold(
          body: Center(child: Text("Page Not Found")),
        ),
      );
  }
}
