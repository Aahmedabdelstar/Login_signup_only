import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

abstract class BaseAuth{
  String UserID;
  Future<String> signInWithEmailAndPassword(String email , String password);
  Future<String> createUserWithEmailAndPassword(String email , String password);
  Future<String> currentUser();
  Future<void> signOut();
  Future<void> sendPasswordRestEmail(String email);
  void inputData();
}

class Auth implements BaseAuth{
  @override
  String UserID;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  /// register
  Future<String> createUserWithEmailAndPassword(String email, String password) async {
    FirebaseUser user = (await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password)).user;
    return user.uid;
  }

  /// Log in
  Future<String> signInWithEmailAndPassword(String email, String password) async{
    FirebaseUser user = (await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password)).user;
    return user.uid;
  }

  /// userID
  Future<String> currentUser() async{
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.uid;
  }

  void inputData() async {
    final FirebaseUser user = await _firebaseAuth.currentUser();
    final uid = user.uid;
    UserID=uid;
  }

  /// Sign Out
  Future<void> signOut()async{
    return _firebaseAuth.signOut();
  }

  /// Reste Password
  /// Reste Password
  /// Reste Password
  Future<void> sendPasswordRestEmail(String email)async{
    return _firebaseAuth.sendPasswordResetEmail(email: email);
  }




}