// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:icalendar_parser/icalendar_parser.dart';
import 'dart:convert';

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

Future<List<Map<String, dynamic>>> fetchCalendarData(String icalLink) async {
  try {
    final response = await http.get(Uri.parse(icalLink));

    if (response.statusCode == 200) {
      final List<String> lines = LineSplitter.split(utf8.decode(response.bodyBytes)).toList();

      ICalendar calendar = ICalendar.fromLines(lines);

      return calendar.data;
    } else {
      throw ErrorDescription("HTTP request failed");
    }
  } catch (e) {
    throw Error();
  }
}

/// Returns a list of [DateTime] objects from [first] to [last], inclusive.
List<DateTime> daysInRange(DateTime first, DateTime last) {
  final dayCount = last.difference(first).inDays + 1;
  return List.generate(
    dayCount,
        (index) => DateTime.utc(first.year, first.month, first.day + index),
  );
}

// TODO: optimize in the future
final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year, kToday.month - 5, kToday.day);
final kLastDay = DateTime(kToday.year, kToday.month + 5, kToday.day);