import 'package:flutter_dotenv/flutter_dotenv.dart';

class UIData {
  static const String imageDir = "assets/images";

  static const String angryGif = '$imageDir/angry.gif';
  static const String hahaGif = '$imageDir/haha.gif';
  static const String likeGif = '$imageDir/like.gif';
  static const String loveGif = '$imageDir/love.gif';
  static const String sadGif = '$imageDir/sad.gif';
  static const String wowGif = '$imageDir/wow.gif';
}

class LINK_IMAGE {
  static final String PUBLIC_URL_IMAGE = dotenv.env['PUBLIC_URL_IMAGE'] ?? '';

  static String publicImage(String imageName) {
    if (imageName.isEmpty) return ''; // or return a default placeholder path
    return '$PUBLIC_URL_IMAGE$imageName';
  }
}
