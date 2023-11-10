import 'package:flutter/material.dart';
// import 'package:quiz_app/helpers/funtions.dart';
import 'package:quiz_app/services/auth.dart';
import 'package:quiz_app/views/home.dart';
import 'package:quiz_app/views/signup.dart';
import 'package:quiz_app/widgets/widgets.dart';

import '../helpers/funstions.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  late String email, password;
  AuthService authService = new AuthService();
  bool _isLoading = false;
  String error = "";

  signIn() async {
    if(_formKey.currentState!.validate()){
      setState(() {
        _isLoading=true;
      });
      authService.signInEmailAndPassword(email, password).then((value){
        if(value!=null){
          setState(() {
              _isLoading=false;
            });
            HelperFunctions.saveUserLoggedInDetails(isLoggedIn:true);
            Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context)=>Home()
            ));
        }
        else{
          setState(() {
              _isLoading=false;
              error="User Credentials Are Wrong";
            });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: appBar(context)),
        backgroundColor: Colors.white,
        elevation: 0.0,
        brightness: Brightness.light,
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
                      height: 80,
                    ),
                  ],
                ),
              )),
    );
  }
}
