import 'package:enroute_x/pages/home_page.dart';
import 'package:enroute_x/pages/login_page.dart';
import 'package:enroute_x/pages/signup_page.dart';
import 'package:enroute_x/utils/routes.dart';
import 'package:flutter/material.dart';

void main() {
  return runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.system,
      // theme: MyThemes.lightTheme(context),
      debugShowCheckedModeBanner: false,
      // darkTheme: MyThemes.darkTheme(context),
      initialRoute: MyRoutes.loginRoute,
      routes: {
        "/": (context) => LoginPage(),
        MyRoutes.homeRoute: (context) => HomePage(),
        MyRoutes.loginRoute: (context) => LoginPage(),
        MyRoutes.signupRoute: (context) => SignUpPage(),
      },
    );
  }
}
