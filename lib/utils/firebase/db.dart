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

  // ======================== USER API ======================== 
  Future<String> getICalLink() async {
    try {
      DocumentSnapshot doc = await usersCollection.doc(uid).get();
      var data = doc.data() as Map<String, dynamic>;
      return data['ical'];
    } catch (e) {
      print(e);
      throw Error();
    }
  }

  // ======================== EVENTS API ======================== 
  Future syncEvents(List<Map<String, dynamic>> IcalData) async {
    try {
      // clean data
      IcalData.removeWhere((event) => 
        event.containsKey("uid") &&
        event.containsKey("summary"));
      
      // initialize firestore references
      final batch = FirebaseFirestore.instance.batch();

      // batch write
      for (var doc in IcalData) {
        DocumentReference eventsCollection = usersCollection.doc(uid).collection("events").doc(doc["uid"]);
        batch.set(eventsCollection, {
          "uid": doc["uid"],
          "dtstart": doc["dtstart"],
          "dtend": doc["dtend"],
          "summary": doc["summary"],
        });
      }

      await batch.commit();
    } catch (e) {
      print(e);
    }
  }

  Future getAllEvents() async {
    try {
      QuerySnapshot doc = await usersCollection.doc(uid).collection("events").get();
      final data = doc.docs.map((e) => e.data()) as Map<String, dynamic>;

      return data;
    } catch (e) {
      print(e);
    }
  }

  Future getEventsWhere() async {
    try {

    } catch (e) {
      print(e);
    }
  }

  Future addEvents() async {
    try {

    } catch (e) {
      print(e);
    }
  }

  Future updateEvents() async {
    try {
      
    } catch (e) {
      print(e);
    }
  }

  Future deleteEvents() async {
    try {
      
    } catch (e) {
      print(e);
    }
  }
}