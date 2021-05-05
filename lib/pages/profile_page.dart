import 'dart:io';
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
  File? _image;
  final picker = ImagePicker();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isloggedin = false;
  User? user;

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

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
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
        onPressed: getImage,
        child: Icon(Icons.edit),
      ),
      drawer: Drawer(
        child: MyDrawer(),
      ),
      body: Material(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _image == null
                ? "No Image".text.make().centered()
                : Container(
                    width: 200,
                    height: 200,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: FileImage(_image!),
                      ),
                    ),
                    // child: Image.file(
                    //   _image!,
                    // ),
                  ),
          ],
        ),
      ),
    );
  }
}
