import 'package:quiz_app/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService{

  FirebaseAuth _auth=FirebaseAuth.instance;

  CustomUser? _userFromFirebaseUser(User user){
    return user !=null ? CustomUser(uid:user.uid) : null;
  }

  Future signInEmailAndPassword(String email,String password) async {
    try{
      UserCredential authResult=await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? firebaseUser=authResult.user;
      return _userFromFirebaseUser(firebaseUser!);
    }catch(e){
      print(e.toString());
    }
  }



  Future signUpEmailAndPassword(String email,String password) async {
    try{
      UserCredential authResult=await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? firebaseUser=authResult.user;
      return _userFromFirebaseUser(firebaseUser!);
    }catch(e){
      print(e.toString());
    }
  }


  Future signout() async {
    try{
      return await _auth.signOut();
    }catch(e){
      print(e.toString());
      return null;
    }
  }

}