import 'package:enroute_x/utils/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // String name = "";
  bool changeButton = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _email = "", _password = "";
  final _formKey = GlobalKey<FormState>();

  checkAuthentication() async {
    _auth.authStateChanges().listen((user) {
      if (user != null) {
        print(user);

        Navigator.pushReplacementNamed(context, MyRoutes.homeRoute);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    this.checkAuthentication();
  }

  login() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        await _auth.signInWithEmailAndPassword(
            email: _email, password: _password);
        return "login successful";
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          print('No user found for that email.');
        } else if (e.code == 'wrong-password') {
          print('Wrong password provided for that user.');
        }
      }
    }
  }

  // moveToHome(BuildContext context) async {
  //   if (_formKey.currentState!.validate()) {
  //     setState(() {
  //       changeButton = true;
  //     });
  //     await Future.delayed(Duration(milliseconds: 300));
  //     await Navigator.pushNamed(context, MyRoutes.homeRoute);
  //     setState(() {
  //       changeButton = false;
  //     });
  //   }
  // }

  moveToSignUp(BuildContext context) async {
    await Future.delayed(Duration(milliseconds: 300));
    await Navigator.pushNamed(context, MyRoutes.signupRoute);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.canvasColor,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(
                    height: 40,
                  ),
                  Text(
                    "EnRoute-X",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Image.asset(
                    "assets/images/loginimage.png",
                    fit: BoxFit.cover,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Welcome ",
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
                            prefixIcon: Icon(Icons.mail),
                            hintText: "Enter Email",
                            labelText: "Email",
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "username cannot be empty";
                            }
                            return null;
                          },
                          // onChanged: (value) {
                          //   name = value;
                          //   setState(() {});
                          // },
                          onSaved: (input) {
                            _email = input!;
                          },
                        ),
                        TextFormField(
                          obscureText: true,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.lock),
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
                          onSaved: (input) {
                            _password = input!;
                          },
                        ),
                        SizedBox(
                          height: 60,
                        ),
                        Material(
                          color:
                              changeButton ? Colors.green : Colors.deepOrange,
                          borderRadius:
                              BorderRadius.circular(changeButton ? 50 : 8),
                          child: InkWell(
                            onTap: () => login(),
                            child: AnimatedContainer(
                              duration: Duration(seconds: 1),
                              height: 50,
                              width: changeButton ? 50 : 150,
                              alignment: Alignment.center,
                              child: changeButton
                                  ? Icon(
                                      Icons.done,
                                      color: Colors.white,
                                    )
                                  : Text(
                                      "Login",
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
                  )
                ],
              ),
            ),
            "Don't have an accout?? Sign Up Here.."
                .text
                .bold
                .lg
                .color(Colors.grey)
                .make()
                .p12(),
            Material(
              color: changeButton ? Colors.green : Colors.deepOrange,
              borderRadius: BorderRadius.circular(changeButton ? 50 : 8),
              child: InkWell(
                onTap: () => moveToSignUp(context),
                child: AnimatedContainer(
                  duration: Duration(seconds: 1),
                  height: 50,
                  width: changeButton ? 50 : 150,
                  alignment: Alignment.center,
                  child: changeButton
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
    );
  }
}
