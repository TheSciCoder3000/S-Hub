import 'dart:async';

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
        String eventId = doc["uid"];

        batch.set(eventsCollection, {
          "uid": doc["uid"],
          "category": eventId.split("-").first,
          "dtstart": dtstart?.toDateTime()?.toIso8601String(),
          "dtend": dtend?.toDateTime()?.toIso8601String(),
          "summary": doc["summary"],
          "completed": false
        });
      }

      await batch.commit();
    } catch (e) {
      throw Exception("Error in syncing ICalLink with firestore");
    }
  }

  Future<List<Map<String, dynamic>>> getAllEvents() async {
    try {
      QuerySnapshot doc = await usersCollection.doc(uid).collection("events").get();
      return doc.docs.map((e) => e.data() as Map<String, dynamic>).toList();
    } catch (e) {
      throw Exception("Error in getting all events");
    }
  }

  Future getEventsWhere() async {
    try {

    } catch (e) {
      throw Exception("Error in getting specific events");
    }
  }

  Future<void> addEvent(String eventId, String eventCategory, String summary, DateTime dtend) async {
    try {
      CollectionReference eventsCollection = usersCollection.doc(uid).collection("events");
      return await eventsCollection.doc(eventId).set({
        "uid": eventId,
        "summary": summary,
        "category": eventCategory,
        "dtend": dtend.toIso8601String(),
        "dtstart": null,
        "completed": false
      });
      
    } catch (e) {
      throw Exception("Error in adding events");
    }
  }

  Future<void> updateEventStatus(String eventId, bool status) async {
    try {
      CollectionReference eventsCollection = usersCollection.doc(uid).collection("events");
      return await eventsCollection.doc(eventId).update({"completed": true});
    } catch (e) {
      throw Exception("Error in updating event status");
    }
  }

  Future<void> deleteEvent(String eventId) async {
    try {
      CollectionReference eventsCollection = usersCollection.doc(uid).collection("events");
      return await eventsCollection.doc(eventId).delete();
    } catch (e) {
      throw Exception("Error in deleting an event");
    }
  }

  Future<void> deleteEvents(List<String> eventIds) async {
    try {
      final batch = FirebaseFirestore.instance.batch();

      CollectionReference eventsCollection = usersCollection.doc(uid).collection("events");
      final query = await eventsCollection.where("uid", whereIn: eventIds).get();

      for (var event in query.docs) {
        batch.delete(event.reference);
      }

      batch.commit();
    } catch (e) {
      throw Exception("Error in deleting an event");
    }
  }
}