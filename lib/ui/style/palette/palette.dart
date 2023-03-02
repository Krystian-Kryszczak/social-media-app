import 'package:flutter/material.dart';

class Palette {
  static String appTitleData = 'App';
  static Text appTitle(BuildContext context) => Text(appTitleData,
      style: TextStyle(
        color: Theme.of(context).colorScheme.secondary,
        fontSize: 32.0, fontWeight: FontWeight.bold,
        letterSpacing: -1.2,
      ));

  static const Color primaryColor = Color(0xff1e88e5);
  static const Color lightColor = Colors.white;
  static const Color darkColor = Colors.black;

  static const String fontFamily = 'sans-serif';

  static const Color upVoteColor = Color(0xFF4BCB1F);
  static const Color downVoteColor = Color(0xFFCB1F4B);

  static const Color focusColor = Color(0xff64a5ff);

  static const Color choiceChipColor = Color(0xff1e88e5);
  static const Color choiceChipBackgroundColor = Color(0xFF14212F);
  static TextStyle appBarTitleStyle(BuildContext context) => TextStyle(
    color: Theme.of(context).primaryColor,
    fontSize: 28.0,
    fontWeight: FontWeight.bold,
    letterSpacing: -1.2,
  );
  static TextStyle profileAppBarTitleStyle(BuildContext context) => const TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.bold,
    letterSpacing: -1.2,
  );
  static TextStyle createAppBarTitleStyle(BuildContext context) => const TextStyle(
    color: Colors.black,
    fontSize: 24.0,
    letterSpacing: -1,
  );

  static const Color selectedColor = Color(0xFFC8EBFF);

  static const LinearGradient roomGradient = LinearGradient(
    colors: [primaryColor /*Color(0xFF496AE1)*/, Color(0xFFCE48B1)],
  );

  static const Color onlineColor = Color(0xFF4BCB1F);

  static const LinearGradient storyGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Colors.transparent, Colors.black26],
  );

  static LinearGradient mainGradient = const LinearGradient(
    colors: [Color(0xFF255aef), Color(0xff42a5f5), Colors.deepPurpleAccent, Colors.deepOrange, Color(0xffd50000)] // Color(0xFF25ef5a),
  );
}
