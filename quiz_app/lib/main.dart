import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app/views/home.dart';
import 'package:quiz_app/views/signin.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.android);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget handleAuth() {
    bool _isTeacher = false;
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          print(snapshot.data!.uid);
          // FirebaseFirestore.instance
          //     .collection("users")
          //     .doc(snapshot.data!.uid)
          //     .snapshots()
          //     .listen(
          //   (DocumentSnapshot snapshot) {
          //     if (snapshot.exists) {
          //       Map<String, dynamic> data =
          //           snapshot.data() as Map<String, dynamic>;
          //       print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
          //       print(data['role']);
          //       if (data['role'] == "teacher") {
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
          return Home(
            uid: snapshot.data!.uid,
          );
        } else {
          return SignIn();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QuizMaker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: handleAuth(),
    );
  }
}
