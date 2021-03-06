import 'package:enroute_x/utils/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class MyDrawer extends StatefulWidget {
  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isloggedin = false;
  late User? user;

  checkAuthentication() async {
    _auth.authStateChanges().listen((user) {
      if (user == null) {
        Navigator.of(context).pushReplacementNamed(MyRoutes.loginRoute);
      }
    });
  }

  getUser() async {
    User? firebaseUser = _auth.currentUser;
    await firebaseUser?.reload();
    firebaseUser = _auth.currentUser;

    if (firebaseUser != null) {
      if (mounted)
        setState(() {
          this.user = firebaseUser;
          this.isloggedin = true;
        });
    }
  }

  signOut() async {
    _auth.signOut();
  }

  @override
  void initState() {
    super.initState();
    this.checkAuthentication();
    this.getUser();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: non_constant_identifier_names
    final ImageUrl = user?.photoURL;
    return Drawer(
      child: Container(
        color: Colors.orange,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              padding: EdgeInsets.zero,
              child: UserAccountsDrawerHeader(
                decoration: BoxDecoration(color: Colors.transparent),
                margin: EdgeInsets.zero,
                accountName: "${user?.displayName}".text.black.make(),
                accountEmail: "${user?.email}".text.black.make(),
                currentAccountPicture: ImageUrl == null
                    ? CircleAvatar(child: Icon(Icons.add_a_photo_rounded))
                    : CircleAvatar(
                        backgroundImage: NetworkImage(ImageUrl),
                      ),
              ),
            ),
            ListTile(
              leading: Icon(
                CupertinoIcons.home,
                color: Colors.black,
              ),
              title: Text(
                "Home",
                textScaleFactor: 1.3,
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              onTap: () => Navigator.pushNamed(context, MyRoutes.homeRoute),
            ),
            ListTile(
              leading: Icon(
                CupertinoIcons.profile_circled,
                color: Colors.black,
              ),
              title: Text(
                "Profile",
                textScaleFactor: 1.3,
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              onTap: () => Navigator.pushNamed(context, MyRoutes.profileRoute),
            ),
            ListTile(
              leading: Icon(
                CupertinoIcons.settings,
                color: Colors.black,
              ),
              title: Text(
                "Settings",
                textScaleFactor: 1.3,
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.logout,
                color: Colors.black,
              ),
              title: Text(
                "Sign Out",
                textScaleFactor: 1.3,
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              onTap: () => signOut(),
            ),
          ],
        ),
      ),
    );
  }
}
