import 'package:enroute_x/utils/routes.dart';
import 'package:enroute_x/widgets/drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:velocity_x/velocity_x.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final picker = ImagePicker();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isloggedin = false;
  late User user;
  String? imageUrl;

  checkAuthentication() async {
    _auth.authStateChanges().listen((user) {
      if (user == null) {
        if (mounted)
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
          this.user = firebaseUser!;
          this.isloggedin = true;
        });
    }
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
        title: "Profile Page".text.black.make(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, MyRoutes.editRoute);
        },
        child: Icon(Icons.edit),
      ),
      drawer: Drawer(
        child: MyDrawer(),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    user.photoURL == null
                        ? CircleAvatar(
                            radius: 60,
                            backgroundImage:
                                AssetImage("assets/images/default.png"),
                          ).p24()
                        : CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.blue,
                            backgroundImage: NetworkImage(user.photoURL!),
                          ).p24(),
                  ],
                ),
                Text(
                  "${user.displayName}",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Text(
                      "Email",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    
                    decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(20)),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        "${user.email}",
                        style: TextStyle(
                          fontSize: 22,
                          // fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
