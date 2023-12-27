import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:icalendar_parser/icalendar_parser.dart';
import 'package:s_hub/utils/utils.dart';
import 'package:table_calendar/table_calendar.dart';

class Event {
  final String uid;
  final String title;
  final String? dtstart;
  final String? dtend;
  final String? summary;

  Event({
    required this.uid,
    required this.title,
    this.dtstart,
    this.dtend,
    this.summary,
  });

  @override
  String toString() => title;
}

class EventState extends ChangeNotifier {
  bool initializing = true;
  LinkedHashMap<DateTime, List<Event>> eventMap 
    = LinkedHashMap<DateTime, List<Event>>(
      equals: isSameDay,
      hashCode: getHashCode,
    );

  void parse(List<Map<String, dynamic>> rawData) {
    // clean data
    rawData.removeWhere((event) => 
      !event.containsKey("uid") &&
      !event.containsKey("summary"));
    
    // adding events to global state

    for (var dat in rawData) {
      DateTime date = DateTime.parse(dat['dtend']);
      IcsDateTime dtend = IcsDateTime(dt: dat['dtend']);

      if (eventMap.containsKey(date)) {
        eventMap[date]?.add(Event(
          uid: dat['uid'],
          title: dat['summary'],
          dtend: dtend.toDateTime()?.toIso8601String()
        ));
      } else {
        eventMap.addAll({
          date: [Event(
            uid: dat['uid'],
            title: dat['summary'],
            dtend: dtend.toDateTime()?.toIso8601String()
          )]
        });
      }
    }

    initializing = false;
    notifyListeners();
  }

  List<Map<String, dynamic>> toList() {
    List<Map<String, dynamic>> eventList = [];

    for (var date in eventMap.entries) {
      for (var event in date.value) {
        print(event.summary);
        eventList.add({
          'uid': event.uid,
          'summary': event.title,
          'dtend': event.dtend,
          'dtstart': event.dtstart
        });
      }
    }
    return eventList;
  }

  void addEvent(DateTime key, Event event) {
    if (eventMap.containsKey(key)) {
      eventMap[key]?.add(event);
    } else {
        eventMap.addAll({
        key: [event],
      });
    }

    // TODO: add Firebase api here

    notifyListeners();
  }
  
}