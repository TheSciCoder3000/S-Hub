import 'package:firebase_auth/firebase_auth.dart';
import 'package:s_hub/models/user.dart';
import 'package:s_hub/utils/firebase/db.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  SUser _userFromFirebaseUser(User? user) {
    return user != null ? SUser(FUser: user) : SUser(hasError: true);
  }

  Stream<SUser> get user {
    return _auth.authStateChanges()
      .map(_userFromFirebaseUser);
    // return _auth.authStateChanges();
  }

  Future<SUser?> signInWithEmail(String email, String password) async{
    UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
    SUser? user = result.user != null ? SUser(FUser: result.user!) : null;
    return user;
  }

  Future<User?> registerWithEmail(String email, String username, String password, String icalLink) async{
    return _auth.createUserWithEmailAndPassword(email: email, password: password)
      .then((creds) async {
        final rawUser = creds.user;
        if (rawUser == null) return null;
        await rawUser.updateDisplayName(username);
        final String uid = rawUser.uid;

        await FirestoreService(uid: uid).createUserEntry(icalLink);

        return creds.user;
      });
  }

  Future signOut() async {
    return await _auth.signOut();
  }
}