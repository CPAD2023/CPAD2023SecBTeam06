import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app/services/auth.dart';
import 'package:quiz_app/services/database.dart';
import 'package:quiz_app/views/create_quiz.dart';
import 'package:quiz_app/views/play_quiz.dart';
import 'package:quiz_app/views/signin.dart';
import 'package:quiz_app/widgets/widgets.dart';

class Home extends StatefulWidget {
  final String uid;
  Home({required this.uid});
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Stream quizStream;
  bool _isLoading = false;
  bool _isTeacher = false;
  String searchValue = "";
  DatabaseService databaseService = new DatabaseService();
  final StreamController<List<DocumentSnapshot>> _controller =
      StreamController<List<DocumentSnapshot>>();

  @override
  void initState() {
    print("###########################");
    print(widget.uid);
    setState(() {
      _isLoading = true;
    });
    databaseService.getQuizData().then((val) {
      setState(() {
        quizStream = val;
        _isLoading = false;
      });
    });
    FirebaseFirestore.instance
        .collection("users")
        .doc(widget.uid)
        .snapshots()
        .listen(
      (DocumentSnapshot snapshot) {
        if (snapshot.exists) {
          Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
          print(data['role']);
          if (data['role'] == 'teacher') {
            setState(() {
              _isTeacher = true;
            });
          }
        } else {
          print("snapshot does not exist");
        }
      },
      onError: (error) {
        print('Error fetching data: $error');
      },
    );
    super.initState();
  }

  void searchQuiz() {}

  Widget quizList() {
    // return Column(
    //   children: [
    //     Container(
    //       margin: EdgeInsets.symmetric(horizontal: 24),
    //       child: Row(
    //         children: [
    //           Expanded(
    //             child: Container(
    //               // margin: EdgeInsets.symmetric(horizontal: 24),
    //               child: TextFormField(
    //                 decoration: InputDecoration(hintText: "Search Quiz"),
    //                 onChanged: (val) {
    //                   searchValue = val;
    //                 },
    //               ),
    //             ),
    //           ),
    //           ElevatedButton(
    //             style: ElevatedButton.styleFrom(
    //               primary: Colors.blue, // background
    //               onPrimary: Colors.white, // foreground
    //             ),
    //             onPressed: () {
    //               searchQuiz();
    //             },
    //             child: Text('Search'),
    //           )
    //         ],
    //       ),
    //     ),
    //     SizedBox(
    //       height: 20,
    //     ),
    //     Expanded(
    //       child: Container(
    //           margin: EdgeInsets.symmetric(horizontal: 24),
    //           child: StreamBuilder(
    //             stream: quizStream,
    //             builder: (context, snapshot) {
    //               return snapshot.data == null
    //                   ? Container()
    //                   : ListView.builder(
    //                       itemCount: snapshot.data.docs.length,
    //                       itemBuilder: (context, index) {
    //                         return QuizTile(
    //                           imageUrl: snapshot.data.docs[index]
    //                               ['quizImageUrl'],
    //                           title: snapshot.data.docs[index]['quizTitle'],
    //                           desc: snapshot.data.docs[index]['quizDesc'],
    //                           quizId: snapshot.data.docs[index]["quizId"],
    //                         );
    //                       },
    //                     );
    //             },
    //           )),
    //     ),
    //   ],
    // );

    // ),
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 24),
        child: StreamBuilder(
          stream: quizStream,
          builder: (context, snapshot) {
            return snapshot.data == null
                ? Container()
                : ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, index) {
                      return QuizTile(
                        imageUrl: snapshot.data.docs[index]['quizImageUrl'],
                        title: snapshot.data.docs[index]['quizTitle'],
                        desc: snapshot.data.docs[index]['quizDesc'],
                        quizId: snapshot.data.docs[index]["quizId"],
                      );
                    },
                  );
          },
        ));
  }

  @override
  Widget build(BuildContext context) {
    AuthService authService = new AuthService();

    return Scaffold(
        appBar: AppBar(
            title: Center(child: appBar(context)),
            backgroundColor: Colors.white,
            elevation: 0.0,
            // brightness: Brightness.light,
            actions: [
              GestureDetector(
                onTap: () {
                  authService.signout().then((value) => {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => SignIn()))
                      });
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 25.0),
                  child: Icon(
                    Icons.logout_outlined,
                    color: Colors.grey,
                  ),
                ),
              )
            ]),
        body: _isLoading
            ? Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : quizList(),
        floatingActionButton: _isTeacher
            ? FloatingActionButton(
                child: Icon(Icons.add),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => CreateQuiz()));
                },
              )
            : null);
  }
}

class QuizTile extends StatelessWidget {
  DatabaseService databaseService = new DatabaseService();
  final String imageUrl, title, desc, quizId;
  QuizTile(
      {required this.imageUrl,
      required this.title,
      required this.desc,
      required this.quizId});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        databaseService
            .deleteQuiz(quizId)
            .then((value) => print("quiz deleted"));
      },
      onTap: () {
        print("on tab quiz id is $quizId");
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PlayQuiz(quizId: quizId),
            ));
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 8),
        height: 150,
        child: Stack(
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  imageUrl,
                  width: MediaQuery.of(context).size.width - 48,
                  fit: BoxFit.cover,
                )),
            Container(
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Text(
                    desc,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
