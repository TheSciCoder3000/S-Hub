// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0

import 'dart:collection';
import 'package:http/http.dart' as http;
import 'package:table_calendar/table_calendar.dart';
import 'package:icalendar_parser/icalendar_parser.dart';
import 'dart:convert';

/// Example event class.
class Event {
  final String title;

  const Event(this.title);

  @override
  String toString() => title;
}

String ICAL = "EMPTY";
String iCalLink = "Insert ICal Link";

void setCalendar() async {

  try {
    final response = await http.get(Uri.parse("https://dlsud.edu20.org/my_calendar/ical/calendar.ics?code=6289cbd05d12cd160876e768ee36203a3435f79f&user_id=9220986"));

    if (response.statusCode == 200) {
      final List<String> lines = LineSplitter.split(utf8.decode(response.bodyBytes)).toList();

      // Now 'lines' contains a list of strings, where each string represents a line from the URL content
      final icsObj = ICalendar.fromLines(lines);

      ICAL = jsonEncode(icsObj.toJson());
      for (var dat in icsObj.data) {
        print(dat);
      }

    } else {
      print('Failed to load data. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
  }
}

/// Example events.
///
/// Using a [LinkedHashMap] is highly recommended if you decide to use a map.
final kEvents = LinkedHashMap<DateTime, List<Event>>(
  equals: isSameDay,
  hashCode: getHashCode,
)..addAll(
    {
      kToday: [
        Event('Today\'s Event 1'),
        Event('Today\'s Event 2'),
      ],
    }
);


int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

/// Returns a list of [DateTime] objects from [first] to [last], inclusive.
List<DateTime> daysInRange(DateTime first, DateTime last) {
  final dayCount = last.difference(first).inDays + 1;
  return List.generate(
    dayCount,
        (index) => DateTime.utc(first.year, first.month, first.day + index),
  );
}

final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year, kToday.month - 3, kToday.day);
final kLastDay = DateTime(kToday.year, kToday.month + 3, kToday.day);