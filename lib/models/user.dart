
import 'package:firebase_auth/firebase_auth.dart';

class SUser {
  String? uid;
  bool initializing;
  bool hasError;
  String? displayName;

  SUser({
    User? FUser, 
    this.initializing = false,
    this.hasError = false,
  }) :
    uid = FUser?.uid, 
    displayName = FUser?.displayName;
}