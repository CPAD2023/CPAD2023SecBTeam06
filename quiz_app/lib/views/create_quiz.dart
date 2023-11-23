import 'package:flutter/material.dart';
import 'package:quiz_app/services/database.dart';
import 'package:quiz_app/views/addquestion.dart';
import 'package:quiz_app/widgets/widgets.dart';
import 'package:random_string/random_string.dart';

class CreateQuiz extends StatefulWidget {
  @override
  _CreateQuizState createState() => _CreateQuizState();
}

class _CreateQuizState extends State<CreateQuiz> {

  final _formKey=GlobalKey<FormState>();
  late String quizImageUrl,quizTitle,quizDescription,quizId;
  DatabaseService databaseService=new DatabaseService();
  bool _isLoading=false;

  createQuizOnline(){
    if(_formKey.currentState!.validate()){
      setState(() {
        _isLoading=true;
      });
      quizId=randomAlphaNumeric(16);
      Map<String,String> quizMap={
        "quizId":quizId,
        "quizImageUrl":quizImageUrl,
        "quizTitle":quizTitle,
        "quizDesc":quizDescription
      };
      databaseService.addQuizData(quizMap, quizId).then((value) => 
        setState(() {
        _isLoading=false;
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context)=>AddQuestion(quizId: quizId,)
        ));
      })
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child:appBar(context)),
        backgroundColor: Colors.white,
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.black87),
        brightness: Brightness.light,
      ),
      body: _isLoading ? Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ) : Form(
          key: _formKey,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal:16),
          child: Column(
            children: [
              TextFormField(
                validator:(val)=>val!.isEmpty ? "Enter Image url" : null,
                decoration: InputDecoration(
                  hintText: "Enter Quiz Image Url"
                ),
                onChanged: (val){
                  quizImageUrl=val;
                },
              ),
              SizedBox(height: 6,),
              TextFormField(
                validator:(val)=>val!.isEmpty ? "Enter Quiz Title" : null,
                decoration: InputDecoration(
                  hintText: "Enter Quiz Title"
                ),
                onChanged: (val){
                  quizTitle=val;
                },
              ),
              SizedBox(height: 6,),
              TextFormField(
                validator:(val)=>val!.isEmpty ? "Enter Quiz Description" : null,
                decoration: InputDecoration(
                  hintText: "Enter Quiz Description"
                ),
                onChanged: (val){
                  quizDescription=val;
                },
              ),
              Spacer(),
              GestureDetector(
                onTap: (){
                  createQuizOnline();
                },
                child: blueButton(
                  context: context,
                  label: "Create Quiz"
                )
                ),
              SizedBox(height: 40,)
            ],
          ),
        ),
      ),
    );
  }
}