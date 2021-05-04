
import 'package:enroute_x/utils/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  String _name = "";
  String _password = "";
  String _email = "";
  bool signupButton = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();

  checkAuthentication() async {
    _auth.authStateChanges().listen((user) {
      if (user != null) {
        Navigator.of(context).pushReplacementNamed(MyRoutes.homeRoute);
      }
    });
  }

  // moveToHome(BuildContext context) async {
  //   if (_formKey.currentState!.validate()) {
  //     setState(() {
  //       signupButton = true;
  //     });
  //     await Future.delayed(Duration(milliseconds: 300));
  //     await Navigator.pushNamed(context, MyRoutes.loginRoute);
  //     setState(() {
  //       signupButton = false;
  //     });
  //   }
  // }
            
  @override
  void initState() {
    super.initState();
    this.checkAuthentication();
  }

  signUp() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
         await _auth.createUserWithEmailAndPassword(
            email: _email, password: _password);
        await _auth.currentUser!.updateProfile(displayName: _name);
      } catch (e) {
        showError(e.toString());
        print(e);
      }
    }
  }

  showError(String errormessage) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('ERROR'),
            content: Text(errormessage),
            actions: <Widget>[
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: "EnRoute-X".text.black.make(),
        iconTheme: IconThemeData.fallback(),
      ),
      body: Material(
        color: context.canvasColor,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(
                  height: 40,
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Welcome to Sign Up",
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
                          } else if (value.length < 6) {
                            return "Password length should be at least 6";
                          }
                          return null;
                        },
                        onChanged: (value) {
                          _password = value;
                        },
                      ),
                      TextFormField(
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: "Re-enter Password",
                          labelText: "Confirm Password",
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Password cannot be empty";
                          } else if (value != _password) {
                            return "Password doesn't match";
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 60,
                      ),
                      Material(
                        color: signupButton ? Colors.green : Colors.deepOrange,
                        borderRadius:
                            BorderRadius.circular(signupButton ? 50 : 8),
                        child: InkWell(
                          onTap: () => signUp(),
                          child: AnimatedContainer(
                            duration: Duration(seconds: 1),
                            height: 50,
                            width: signupButton ? 50 : 150,
                            alignment: Alignment.center,
                            child: signupButton
                                ? Icon(
                                    Icons.done,
                                    color: Colors.white,
                                  )
                                : Text(
                                    "Sign Up",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}



