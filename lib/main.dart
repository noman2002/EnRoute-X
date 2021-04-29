import 'package:enroute_x/pages/home_page.dart';
import 'package:enroute_x/pages/login_page.dart';
import 'package:enroute_x/pages/signup_page.dart';
import 'package:enroute_x/utils/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
