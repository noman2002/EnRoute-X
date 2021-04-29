import 'package:enroute_x/utils/routes.dart';
import 'package:enroute_x/widgets/drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isloggedin = false;
  User? user;

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
      setState(() {
        this.user = firebaseUser!;
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
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData.fallback(),
        backgroundColor: Colors.orange,
        title: "EnRoute-X".text.black.make(),
      ),
      drawer: Drawer(
        child: MyDrawer(),
      ),
      body: !isloggedin
          ? CircularProgressIndicator().centered()
          : Material(
              child: Column(
                children: [
                  ElevatedButton(onPressed: signOut(), child: Text("SignOut")),
                ],
              ),
            ),
    );
  }
}
