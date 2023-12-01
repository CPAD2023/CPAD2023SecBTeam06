import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
// import 'package:quiz_app/helpers/funtions.dart';
import 'package:quiz_app/services/auth.dart';
import 'package:quiz_app/views/home.dart';
import 'package:quiz_app/views/signup.dart';
import 'package:quiz_app/widgets/widgets.dart';
import 'package:quiz_app/services/database.dart';
import '../helpers/funstions.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  late String email, password;
  AuthService authService = new AuthService();
  DatabaseService databaseService = new DatabaseService();
  bool _isLoading = false;
  bool _isTeacher = false;
  String error = "";

  signIn() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      authService.signInEmailAndPassword(email, password).then((uid) {
        if (uid != null) {
          // FirebaseFirestore.instance
          //     .collection("users")
          //     .doc(uid)
          //     .snapshots()
          //     .listen(
          //   (DocumentSnapshot snapshot) {
          //     if (snapshot.exists) {
          //       Map<String, dynamic> data =
          //           snapshot.data() as Map<String, dynamic>;
          //       print("+++++++++ $uid");
          //       print(data['role']);
          //       if (data['role'] == 'teacher') {
          //         _isTeacher = true;
          //       }
          //     } else {
          //       print("snapshot does not exist");
          //     }
          //   },
          //   onError: (error) {
          //     print('Error fetching data: $error');
          //   },
          // );
          setState(() {
            _isLoading = false;
          });
          HelperFunctions.saveUserLoggedInDetails(isLoggedIn: true);
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => Home(
                        uid: uid,
                      )));
        } else {
          setState(() {
            _isLoading = false;
            error = "User Credentials Are Wrong";
          });
        }
      });
    }
  }

  signInWithGoogle() async {
    setState(() {
      _isLoading = true;
    });
    try {
      print("+++++++++++++++befor execution of google sigin +++++++++++++++++");
      GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      print("================googleUser $googleUser ======");
      GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
      print("================ googleAuth $googleAuth ======");
      AuthCredential authCredential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);
      print("================ authCredential $authCredential ======");
      UserCredential user =
          await FirebaseAuth.instance.signInWithCredential(authCredential);
      setState(() {
        _isLoading = false;
      });
      HelperFunctions.saveUserLoggedInDetails(isLoggedIn: true);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => Home(
                    uid: user.user!.uid,
                  )));
    } catch (e) {
      print(" ______________+++++++ $e.toString() ++++++++++++++++");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: appBar(context)),
        backgroundColor: Colors.white,
        elevation: 0.0,
        // brightness: Brightness.light,
      ),
      body: _isLoading
          ? Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Form(
              key: _formKey,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    Spacer(),
                    TextFormField(
                      validator: (val) {
                        return val!.isEmpty ? "Enter email" : null;
                      },
                      decoration: InputDecoration(hintText: "Email"),
                      onChanged: (val) {
                        email = val;
                      },
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    TextFormField(
                      obscureText: true,
                      validator: (val) {
                        return val!.isEmpty ? "Enter Password" : null;
                      },
                      decoration: InputDecoration(hintText: "Password"),
                      onChanged: (val) {
                        password = val;
                      },
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    Text(
                      "${error}",
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                    GestureDetector(
                        onTap: () {
                          signIn();
                        },
                        child: blueButton(context: context, label: "Sign In")),
                    SizedBox(
                      height: 18,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't Have an Account ? ",
                          style: TextStyle(fontSize: 15),
                        ),
                        GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SignUp(),
                                  ));
                            },
                            child: Text(
                              "Sign Up",
                              style: TextStyle(
                                  fontSize: 15,
                                  decoration: TextDecoration.underline),
                            )),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        signInWithGoogle();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 18),
                        decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(30)),
                        alignment: Alignment.center,
                        width: MediaQuery.of(context!).size.width - 48,
                        child: Row(
                          children: [
                            Icon(
                              FontAwesomeIcons.google,
                              size: 15,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Text(
                              "Sign in with Google",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white),
                            )
                          ],
                          mainAxisAlignment: MainAxisAlignment.center,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 60,
                    ),
                  ],
                ),
              )),
    );
  }
}
