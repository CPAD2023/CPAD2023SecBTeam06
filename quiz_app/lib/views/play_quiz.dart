import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app/models/question_modal.dart';
import 'package:quiz_app/services/database.dart';
import 'package:quiz_app/views/result.dart';
import 'package:quiz_app/widgets/quiz_play_widget.dart';
import 'package:quiz_app/widgets/widgets.dart';

class PlayQuiz extends StatefulWidget {
  final String quizId;
  PlayQuiz({required this.quizId});
  @override
  _PlayQuizState createState() => _PlayQuizState();
}

int total=0,_correct=0,_incorrect=0,_notAttempted=0;

class _PlayQuizState extends State<PlayQuiz> {

  DatabaseService databaseService=new DatabaseService();
  late Stream questionSnapshot;

  QuestionModal getQuestionModalDataFromSnapshot(questionSnapshot){
    QuestionModal questionModal=new QuestionModal();
    questionModal.question=questionSnapshot['question'];

    List<String> options=[
      questionSnapshot['option1'],
      questionSnapshot['option2'],
      questionSnapshot['option3'],
      questionSnapshot['option4']
    ];
    options.shuffle();
    questionModal.option1=options[0];
    questionModal.option2=options[1];
    questionModal.option3=options[2];
    questionModal.option4=options[3];
    questionModal.correctOption=questionSnapshot['option1'];
    questionModal.answered=false;

    return questionModal;
  }

  Widget getSnapshot(){
    databaseService.getQuizQuestions(widget.quizId).then((val) async {
      setState(() {
        questionSnapshot=val;
      });
      _notAttempted=0;
      _correct=0;
      _incorrect=0;
      total=await questionSnapshot.length;
    });

    return Center(child: CircularProgressIndicator());
  }


  @override
  void initState() {
    databaseService.getQuizQuestions(widget.quizId).then((val) async {
      setState(() {
        questionSnapshot=val;
      });
      _notAttempted=0;
      _correct=0;
      _incorrect=0;
      total=await questionSnapshot.length;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child:appBar(context)),
        backgroundColor: Colors.white,
        elevation: 0.0,
        iconTheme: IconThemeData(
          color: Colors.black54
        ),
        brightness: Brightness.light,
      ),
      body: SingleChildScrollView(
              child: Container(
          child: Column(
            children: [
              questionSnapshot == null ?
              Container(
                child: CircularProgressIndicator(),
              ) : 
              StreamBuilder(
                stream: questionSnapshot,
                builder: (context,snapshot){
                  return snapshot.data==null ? getSnapshot() : 
              ListView.builder(
                padding: EdgeInsets.symmetric(horizontal:24),
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context,index){
                  total=snapshot.data.docs.length;
                  return QuizPlayTile(
                    questionModal: getQuestionModalDataFromSnapshot(snapshot.data.docs[index]),
                    index:index
                    );
                },
              );
            },
          ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.check),
        onPressed: (){

          Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context)=>Results(total: total,correct:_correct,incorrect:_incorrect, notattempted: 0,)
          ));
        },
      ),
    );
  }
}



class QuizPlayTile extends StatefulWidget {

  final QuestionModal questionModal;
  final int index;
  QuizPlayTile({required this.questionModal,required this.index});

  @override
  _QuizPlayTileState createState() => _QuizPlayTileState();
}

class _QuizPlayTileState extends State<QuizPlayTile> {
  String optionSelected="";
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Q${widget.index+1} ${widget.questionModal.question}"),
          SizedBox(height: 12,),
          GestureDetector(
            onTap: (){
              print("====================tapped A");
              if(!widget.questionModal.answered){
                if(widget.questionModal.option1==widget.questionModal.correctOption){
                  
                  setState(() {
                        optionSelected=widget.questionModal.option1;
                      widget.questionModal.answered=true;
                      _correct=_correct+1;
                      _notAttempted=_notAttempted-1;
                  });
                }
                else{
                  setState(() {
                          optionSelected=widget.questionModal.option1;
                        widget.questionModal.answered=true;
                        _incorrect=_incorrect+1;
                        _notAttempted=_notAttempted-1;
                    });
                }
              }
              // else{
                
              //     setState(() {
              //       optionSelected=widget.questionModal.option1;
              //       widget.questionModal.answered=true;
              //     _incorrect=_incorrect+1;
              //     _notAttempted=_notAttempted-1;
              //     });
              // }
            },
              child: OptionTile(
              correctAnswer:widget.questionModal.correctOption,
              description:widget.questionModal.option1,
              option:"A",
              optionSelected:optionSelected
            ),
          ),
          SizedBox(height: 4,),
          GestureDetector(
            onTap: (){
              print("====================tapped B");

              if(!widget.questionModal.answered){
                if(widget.questionModal.option2==widget.questionModal.correctOption){
                  
                  setState(() {
                    optionSelected=widget.questionModal.option2;
                    widget.questionModal.answered=true;
                  _correct=_correct+1;
                  _notAttempted=_notAttempted-1;
                  });
                }
                else{
                  setState(() {
                        optionSelected=widget.questionModal.option2;
                      widget.questionModal.answered=true;
                      _incorrect=_incorrect+1;
                      _notAttempted=_notAttempted-1;
                  });
                }
              }
              // else{
                
              //     setState(() {
              //       optionSelected=widget.questionModal.option2;
              //       widget.questionModal.answered=true;
              //     _incorrect=_incorrect+1;
              //     _notAttempted=_notAttempted-1;
              //     });
              // }
            },
            child: OptionTile(
              correctAnswer:widget.questionModal.correctOption,
              description:widget.questionModal.option2,
              option:"B",
              optionSelected:optionSelected
            ),
          ),
          SizedBox(height: 4,),
          GestureDetector(
            onTap: (){
              print("====================tapped C");

              if(!widget.questionModal.answered){
                if(widget.questionModal.option3==widget.questionModal.correctOption){
                  
                  setState(() {
                    optionSelected=widget.questionModal.option3;
                    widget.questionModal.answered=true;
                  _correct=_correct+1;
                  _notAttempted=_notAttempted-1;
                  });
                }
                else{
                  setState(() {
                        optionSelected=widget.questionModal.option3;
                      widget.questionModal.answered=true;
                      _incorrect=_incorrect+1;
                      _notAttempted=_notAttempted-1;
                  });
                }
              }
              // else{
                
              //     setState(() {
              //       optionSelected=widget.questionModal.option3;
              //       widget.questionModal.answered=true;
              //     _incorrect=_incorrect+1;
              //     _notAttempted=_notAttempted-1;
              //     });
              // }
            },
              child: OptionTile(
              correctAnswer:widget.questionModal.correctOption,
              description:widget.questionModal.option3,
              option:"C",
              optionSelected:optionSelected
            ),
          ),
          SizedBox(height: 4,),
          GestureDetector(
            onTap: (){
              print("====================tapped D");

              if(!widget.questionModal.answered){
                if(widget.questionModal.option4==widget.questionModal.correctOption){
                  
                  setState(() {
                    optionSelected=widget.questionModal.option4;
                    widget.questionModal.answered=true;
                  _correct=_correct+1;
                  _notAttempted=_notAttempted-1;
                  });
                }
                else{
                  setState(() {
                        optionSelected=widget.questionModal.option4;
                      widget.questionModal.answered=true;
                      _incorrect=_incorrect+1;
                      _notAttempted=_notAttempted-1;
                  });
                }
              }
              // else{
                
              //     setState(() {
              //       optionSelected=widget.questionModal.option4;
              //       widget.questionModal.answered=true;
              //     _incorrect=_incorrect+1;
              //     _notAttempted=_notAttempted-1;
              //     });
              // }
            },
              child: OptionTile(
              correctAnswer:widget.questionModal.correctOption,
              description:widget.questionModal.option4,
              option:"D",
              optionSelected:optionSelected
            ),
          ),
          SizedBox(height:20),
        ],
      ),
    );
  }
}