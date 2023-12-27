import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:icalendar_parser/icalendar_parser.dart';
import 'package:s_hub/utils/utils.dart';

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
  Future syncEvents() async {
    try {
      String icalLink = await getICalLink();
      List<Map<String, dynamic>> IcalData = await fetchCalendarData(icalLink);

      // clean data
      IcalData.removeWhere((event) => 
        !event.containsKey("uid") &&
        !event.containsKey("summary"));
      
      // initialize firestore references
      final batch = FirebaseFirestore.instance.batch();

      // batch write
      for (var doc in IcalData) {
        DocumentReference eventsCollection = usersCollection.doc(uid).collection("events").doc(doc["uid"]);

        IcsDateTime? dtstart = doc['dtstart'];
        IcsDateTime? dtend = doc['dtend'];

        batch.set(eventsCollection, {
          "uid": doc["uid"],
          "dtstart": dtstart?.toDateTime()?.toIso8601String(),
          "dtend": dtend?.toDateTime()?.toIso8601String(),
          "summary": doc["summary"],
        });
      }

      await batch.commit();
    } catch (e) {
      print(e);
    }
  }

  Future<List<Map<String, dynamic>>> getAllEvents() async {
    try {
      print("getting all events");
      QuerySnapshot doc = await usersCollection.doc(uid).collection("events").get();
      final data = doc.docs.map((e) => e.data() as Map<String, dynamic>).toList();
      return data;
    } catch (e) {
      print(e);
      throw Error();
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