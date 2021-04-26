import 'package:enroute_x/pages/login_page.dart';
import 'package:enroute_x/utils/routes.dart';
import 'package:enroute_x/widgets/themes.dart';
import 'package:flutter/material.dart';


void main() {
  return runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      themeMode: ThemeMode.system,
      theme: MyThemes.lightTheme(context),
      debugShowCheckedModeBanner: false,
      darkTheme: MyThemes.darkTheme(context),
      initialRoute: MyRoutes.homeRoute,
      routes: {
        "/": (context) => LoginPage(),
        // MyRoutes.homeRoute: (context) => HomePage(),
        MyRoutes.loginRoute: (context) => LoginPage(),
        // MyRoutes.cartRoute: (context) => CartPage(),
      },
      
    );
  }
}