import 'package:flutter/material.dart';
import 'package:quiz_app/services/database.dart';
import 'package:quiz_app/widgets/widgets.dart';

class AddQuestion extends StatefulWidget {
  final String quizId;
  AddQuestion({required this.quizId});
  @override
  _AddQuestionState createState() => _AddQuestionState();
}

class _AddQuestionState extends State<AddQuestion> {
  final _formKey = GlobalKey<FormState>();
  late String question, option1, option2, option3, option4;
  bool _isLoading = false;
  DatabaseService databaseService = new DatabaseService();

  uploadQuestionData() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      Map<String, String> questionMap = {
        "question": question,
        "option1": option1,
        "option2": option2,
        "option3": option3,
        "option4": option4,
      };

      databaseService.addQuestionData(questionMap, widget.quizId).then((value) {
        setState(() {
          _isLoading = false;
        });
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
        iconTheme: IconThemeData(color: Colors.black87),
        // brightness: Brightness.light,
      ),
      body: _isLoading
          ? Container(
              child: Center(
              child: CircularProgressIndicator(),
            ))
          : Form(
              key: _formKey,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    TextFormField(
                      validator: (val) =>
                          val!.isEmpty ? "Enter the Question" : null,
                      decoration:
                          InputDecoration(hintText: "Enter the Question"),
                      onChanged: (val) {
                        question = val;
                      },
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    TextFormField(
                      validator: (val) => val!.isEmpty
                          ? "Enter option1 (Correct answer)"
                          : null,
                      decoration: InputDecoration(
                          hintText: "Enter the option(Correct answer)"),
                      onChanged: (val) {
                        option1 = val;
                      },
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    TextFormField(
                      validator: (val) => val!.isEmpty ? "Enter option2" : null,
                      decoration: InputDecoration(hintText: "Enter the option"),
                      onChanged: (val) {
                        option2 = val;
                      },
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    TextFormField(
                      validator: (val) => val!.isEmpty ? "Enter option3" : null,
                      decoration: InputDecoration(hintText: "Enter the option"),
                      onChanged: (val) {
                        option3 = val;
                      },
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    TextFormField(
                      validator: (val) => val!.isEmpty ? "Enter option4" : null,
                      decoration: InputDecoration(hintText: "Enter the option"),
                      onChanged: (val) {
                        option4 = val;
                      },
                    ),
                    Spacer(),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: blueButton(
                              context: context,
                              label: "Submit",
                              buttonWidth:
                                  MediaQuery.of(context).size.width / 2 - 36),
                        ),
                        SizedBox(width: 24),
                        GestureDetector(
                          onTap: () {
                            uploadQuestionData();
                          },
                          child: blueButton(
                              context: context,
                              label: "Add Question",
                              buttonWidth:
                                  MediaQuery.of(context).size.width / 2 - 36),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
