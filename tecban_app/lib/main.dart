import 'package:custom_splash/custom_splash.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tecban_app/pages/login_page.dart';

import 'controller/controller.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<Controller>(
          create: (_) => Controller(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: CustomSplash(
          imagePath: 'assets/logo_text.png',
          backGroundColor: Colors.white,
          animationEffect: 'zoom-in',
          logoSize: 200,
          home: LoginPage(),
          duration: 2500,
          type: CustomSplashType.StaticDuration,
        ),
      ),
    );
  }
}
