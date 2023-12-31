import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quiz_app/services/auth.dart';
import 'package:quiz_app/services/database.dart';
import 'package:quiz_app/views/home.dart';
import 'package:quiz_app/views/signin.dart';
import 'package:quiz_app/widgets/widgets.dart';

class SignUp extends StatefulWidget {
  // final Function toogleView;

  SignUp();

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  AuthService authService = new AuthService();
  DatabaseService databaseService = new DatabaseService();
  final _formKey = GlobalKey<FormState>();

  bool _loading = false;
  String email = '', password = '', name = "";

  getInfoAndSignUp() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _loading = true;
      });

      await authService.signUpEmailAndPassword(email, password).then((uid) {
        Map<String, String> userInfo = {
          "userName": name,
          "email": email,
          "role": "student",
        };
        databaseService.addData(userInfo,uid);

        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Home(uid: uid,)));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Center(child: appBar(context)),
        backgroundColor: Colors.white,
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.black87),
        // brightness: Brightness.light,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: _loading
            ? Container(
                child: Center(child: CircularProgressIndicator()),
              )
            : Column(
                children: [
                  Spacer(),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          validator: (val) =>
                              val!.isEmpty ? "Enter an Name" : null,
                          decoration: InputDecoration(hintText: "Name"),
                          onChanged: (val) {
                            name = val;
                          },
                        ),
                        // SizedBox(
                        //   height: 6,
                        // ),
                        TextFormField(
                          validator: (val) => validateEmail(email)
                              ? null
                              : "Enter correct email",
                          decoration: InputDecoration(hintText: "Email"),
                          onChanged: (val) {
                            email = val;
                          },
                        ),
                        // SizedBox(
                        //   height: 6,
                        // ),
                        TextFormField(
                          obscureText: true,
                          validator: (val) => val!.length < 6
                              ? "Password must be 6+ characters"
                              : null,
                          decoration: InputDecoration(hintText: "Password"),
                          onChanged: (val) {
                            password = val;
                          },
                        ),
                        SizedBox(
                          height: 18,
                        ),
                        GestureDetector(
                          onTap: () {
                            getInfoAndSignUp();
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.symmetric(
                                horizontal: 24, vertical: 20),
                            decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(30)),
                            child: Text(
                              "Sign Up",
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Already have and account? ',
                                style: TextStyle(
                                    color: Colors.black87, fontSize: 17)),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SignIn(),
                                    ));
                              },
                              child: Container(
                                child: Text('Sign In',
                                    style: TextStyle(
                                        color: Colors.black87,
                                        decoration: TextDecoration.underline,
                                        fontSize: 17)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 80,
                  )
                ],
              ),
      ),
    );
  }
}

bool validateEmail(String value) {
  String pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = new RegExp(pattern);
  return (!regex.hasMatch(value)) ? false : true;
}
