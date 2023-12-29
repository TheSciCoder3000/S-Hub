
import 'package:firebase_auth/firebase_auth.dart';

class SUser {
  String? uid;
  bool initializing;
  bool hasError;
  String? displayName;

  SUser({
    User? userObj, 
    this.initializing = false,
    this.hasError = false,
  }) :
    uid = userObj?.uid, 
    displayName = userObj?.displayName;
}