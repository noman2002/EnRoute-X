import 'dart:io';
import 'package:enroute_x/utils/routes.dart';
import 'package:enroute_x/widgets/drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:velocity_x/velocity_x.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  File? _image;
  final picker = ImagePicker();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isloggedin = false;
  User? user;
  final _storage = FirebaseStorage.instance;
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

  Future uploadImage() async {
    String fileName = _image!.path;
    // var user = _auth.currentUser!;
    if (_image != null) {
      var snapshot = await _storage
          .ref()
          .child('profileImages/$fileName')
          .putFile(_image!);

      await snapshot.ref.getDownloadURL().then((value) => {imageUrl = value});
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Uploaded successfully ImageUrl=$imageUrl"),
      ));
    }
    if (user != null) {
      user!.updateProfile(photoURL: imageUrl);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData.fallback(),
        backgroundColor: Colors.orange,
        title: "Edit Profile ".text.black.make(),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ElevatedButton(
          onPressed: () => uploadImage(),
          child: Text("Save changes"),
        ),
      ),
      drawer: Drawer(
        child: MyDrawer(),
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 60,
                backgroundColor: Colors.blue,
                backgroundImage: AssetImage("assets/images/default.png"),
              ),
              Positioned(
                bottom: 0,
                right: 4,
                child: ClipOval(
                  child: InkWell(
                    child: Container(
                        color: Colors.blue,
                        padding: EdgeInsets.all(8),
                        child: Icon(
                          Icons.edit,
                          color: Colors.white,
                          size: 20,
                        )),
                    onTap: () => getImage(),
                  ),
                ),
              )
            ],
          ).p24(),
        ],
      ),
    );
  }
}
