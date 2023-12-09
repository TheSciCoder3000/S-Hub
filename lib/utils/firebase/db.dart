import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final String uid;
  FirestoreService({required this.uid});
  final CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');

  Future createUserEntry(String icalLink) async {
    return await usersCollection.doc(uid).set({
      "uid": uid,
      "ical": icalLink
    });
  }
}