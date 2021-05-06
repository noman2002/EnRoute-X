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
  User? user;
  String? imageUrl;
  final _formKey = GlobalKey<FormState>();
  String _name = "";
  String _password = "";
  String _email = "";

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
          this.user = firebaseUser;
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
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                user?.photoURL == null
                    ? CircleAvatar(
                        radius: 60,
                        backgroundImage:
                            AssetImage("assets/images/default.png"),
                      ).p24()
                    : CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.blue,
                        backgroundImage: NetworkImage(user!.photoURL!),
                      ).p24(),
              ],
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  Text(
                    "${user?.displayName}",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "$_name",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: "Enter Full Name",
                            labelText: "Full Name",
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "name cannot be empty";
                            }
                            return null;
                          },
                          onChanged: (value) {
                            _name = value;
                            setState(() {});
                          },
                          onSaved: (value) {
                            _name = value!;
                          },
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: "Enter username/Email",
                            labelText: "UserName/Email",
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "username cannot be empty";
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _email = value!;
                          },
                        ),
                        TextFormField(
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: "Enter Password",
                            labelText: "Password",
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Password cannot be empty";
                            }
                          },
                          onChanged: (value) {
                            _password = value;
                          },
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: "Re-enter Password",
                            labelText: "Confirm Password",
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Password cannot be empty";
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
