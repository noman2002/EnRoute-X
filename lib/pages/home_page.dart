import 'package:enroute_x/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData.fallback(),
        backgroundColor: Colors.deepOrange,
        title: "EnRoute-X".text.black.make(),
      ),
      drawer: Drawer(
        child: MyDrawer(),
      ),
    );
  }
}
