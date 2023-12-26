import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:s_hub/utils/utils.dart';


class ICalViewer extends StatefulWidget {
  const ICalViewer({super.key});

  @override
  State<ICalViewer> createState() => _ICalViewerState();
}


class _ICalViewerState extends State<ICalViewer> {

  final myController = TextEditingController();
  late final ValueNotifier<List<Event>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOff; // Can be toggled on/off by longpressing a date
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  @override
  void initState() {
    super.initState();

    _selectedDay = DateTime(kToday.year, kToday.month , kToday.day);
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));

  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  List<Event> _getEventsForDay(DateTime day) {
    // Implementation example
    return kEvents[day] ?? [];
  }

  List<Event> _getEventsForRange(DateTime start, DateTime end) {
    // Implementation example
    final days = daysInRange(start, end);

    return [
      for (final d in days) ..._getEventsForDay(d),
    ];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null; // Important to clean those
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });

      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    setState(() {
      _selectedDay = null;
      _focusedDay = focusedDay;
      _rangeStart = start;
      _rangeEnd = end;
      _rangeSelectionMode = RangeSelectionMode.toggledOn;
    });

    // `start` or `end` could be null
    if (start != null && end != null) {
      _selectedEvents.value = _getEventsForRange(start, end);
    } else if (start != null) {
      _selectedEvents.value = _getEventsForDay(start);
    } else if (end != null) {
      _selectedEvents.value = _getEventsForDay(end);
    }
  }

  @override

  Widget build(BuildContext context) {

    return Scaffold(

      body:Column(

        children: [

          const SizedBox(height: 30,width: 1,),
          TableCalendar<Event>(
            firstDay: kFirstDay,
            lastDay: kLastDay,
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            rangeStartDay: _rangeStart,
            rangeEndDay: _rangeEnd,
            calendarFormat: _calendarFormat,
            rangeSelectionMode: _rangeSelectionMode,
            eventLoader: _getEventsForDay,
            startingDayOfWeek: StartingDayOfWeek.monday,
            calendarStyle: const CalendarStyle(
              // Use `CalendarStyle` to customize the UI
              outsideDaysVisible: false,
              defaultTextStyle: TextStyle(color: Colors.white),
              weekendTextStyle: TextStyle(color: Colors.white),
              weekNumberTextStyle: TextStyle(color: Colors.white),
              markerDecoration: BoxDecoration(color: Colors.greenAccent, shape: BoxShape.circle),
              todayDecoration: BoxDecoration(color: Colors.white38, shape: BoxShape.circle),
              selectedDecoration: BoxDecoration(color: Colors.white54, shape: BoxShape.circle),

            ),
            headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleTextStyle: TextStyle(color: Colors.white),
                leftChevronIcon: Icon(Icons.chevron_left, color: Colors.white),
                rightChevronIcon: Icon(Icons.chevron_right, color: Colors.white)
            ),
            daysOfWeekStyle: const DaysOfWeekStyle(weekdayStyle: TextStyle(color: Colors.white), weekendStyle: TextStyle(color: Colors.white)),
            onDaySelected: _onDaySelected,
            onRangeSelected: _onRangeSelected,
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
          ),
          const SizedBox(height: 8.0),
          Expanded(
            child: ValueListenableBuilder<List<Event>>(
              valueListenable: _selectedEvents,
              builder: (context, value, _) {

                return ListView.builder(
                  itemCount: value.length,
                  itemBuilder: (context, index) {

                    Color color;
                    String summary = "";

                    if (value[index].toString()[0] == '|') {
                      color = Colors.greenAccent;
                      String str = value[index].toString();
                      summary = str.substring(1, str.length);
                    } else {
                      color = Colors.white;
                      String str = value[index].toString();
                      summary = str.substring(0, str.length);
                    }

                    return Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 4.0,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: color),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: ListTile(
                        onTap: () => print('${value[index]}'),
                        title: Text(summary, style: const TextStyle(color: Colors.white),),
                      ),
                    );

                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.greenAccent,
        onPressed: () async {
          var result = await _showTextInputDialog(context);
          print(result);
          if (result != null) {
            setState((){
              addEvent(_selectedDay, result[0], result[1]);
            });
            _selectedEvents.value = _getEventsForDay(_selectedDay!);
          }

        },
        child: const Icon(Icons.add),
      ),

    );
  }
}

final _courseController = TextEditingController();
final _summaryController = TextEditingController();

Future<List<String>?> _showTextInputDialog(BuildContext context) async {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('New Event'),
          content: Container(
            color: Colors.white24,
            height: 100,
            child:  Column(
              children: [
                TextField(
                  controller: _courseController,
                  decoration: const InputDecoration(hintText: "Course"),
                ),
                TextField(
                  controller: _summaryController,
                  decoration: const InputDecoration(hintText: "Event Summary"),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll<Color>(Colors.greenAccent)),
              child: const Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll<Color>(Colors.greenAccent)),
              child: const Text('OK'),
              onPressed: () {

                if (_courseController.text != "" && _summaryController.text != "" ) {
                  Navigator.pop(context, [_courseController.text, _summaryController.text]);
                } else {
                  Navigator.pop(context);
                }

              }
            ),
          ],
        );
      });
}

// prototype calendar generator. Used package instead

// void insertCellsToRows(row, firstRow) {
//   int monthCount = 1;
//   int count = 0;
//   row.add(
//       const SizedBox(
//         height: 530,
//         width: 130,
//         child: Column(
//           children: [
//             Text(
//               'JAN',
//               style: TextStyle(fontSize: 40),
//             )
//           ],
//         ),
//       )
//   );
//
//   //start calendar
//   for (int i = 1; i <= 66; i++) {
//
//     if (i % 6 == 0) {
//       if (firstRow == true) {
//
//         if (i > 1) {count = 0;}
//         row.add(
//             SizedBox(
//               height: 530,
//               width: 160,
//               child: Column(
//                 children: [
//                   Text(
//                     month(monthCount),
//                     style: const TextStyle(fontSize: 40),
//                   )
//                 ],
//               ),
//             )
//         );
//
//       } else {
//         if (i > 1) {count = 0;}
//         row.add(
//             const SizedBox(
//               height: 530,
//               width: 160,
//             )
//         );
//       }
//       monthCount++;
//
//     } else if (firstRow == true) {
//       if (count == 0) {
//         count++;
//         row.add(
//             Container(
//                 decoration: BoxDecoration(
//                     border: setBorder("Top Left")
//                 ),
//                 height: 530,
//                 width: 130,
//                 child: Container(
//                   alignment: Alignment.topLeft,
//                   child: Text(
//                     '$count',
//                     style: const TextStyle(color: Colors.grey),
//                   ),
//                 )
//             )
//         );
//       } else {
//         count++;
//         row.add(
//             Container(
//                 decoration: BoxDecoration(
//                     border: setBorder("Top")
//                 ),
//                 height: 530,
//                 width: 130,
//                 child: Container(
//                   alignment: Alignment.topLeft,
//                   child: Text(
//                     '$count',
//                     style: const TextStyle(color: Colors.grey),
//                   ),
//                 )
//             )
//         );
//       }
//
//     } else {
//       if (count == 0) {
//         count++;
//         row.add(
//             Container(
//                 decoration: BoxDecoration(
//                     border: setBorder("Left")
//                 ),
//                 height: 530,
//                 width: 130,
//                 child: Container(
//                   alignment: Alignment.topLeft,
//                   child: Text(
//                     '$count',
//                     style: const TextStyle(color: Colors.grey),
//                   ),
//                 )
//             )
//         );
//       } else {
//         count++;
//         row.add(
//             Container(
//                 decoration: BoxDecoration(
//                     border: setBorder("Center")
//                 ),
//                 height: 530,
//                 width: 130,
//                 child: Container(
//                   alignment: Alignment.topLeft,
//                   child: Text(
//                     '$count',
//                     style: const TextStyle(color: Colors.grey),
//                   ),
//                 )
//             )
//         );
//       }
//
//     }
//
//   }
// }
//
// Border setBorder(side) {
//   Border border = const Border();
//
//   if (side == "Left") {
//     border = const Border(
//       bottom: BorderSide(color: Colors.grey),
//       right: BorderSide(color: Colors.grey),
//       left: BorderSide(color: Colors.grey),
//     );
//   } else if (side == "Top") {
//     border = const Border(
//       bottom: BorderSide(color: Colors.grey),
//       right: BorderSide(color: Colors.grey),
//       top: BorderSide(color: Colors.grey),
//     );
//   } else if (side == "Top Left") {
//     border = const Border(
//       bottom: BorderSide(color: Colors.grey),
//       right: BorderSide(color: Colors.grey),
//       top: BorderSide(color: Colors.grey),
//       left: BorderSide(color: Colors.grey),
//     );
//   } else if (side == "Center") {
//     border = const Border(
//       bottom: BorderSide(color: Colors.grey),
//       right: BorderSide(color: Colors.grey),
//     );
//   }
//   return border;
// }
//
// String month(numOfMonth) {
//
//   String returnMonth = "None";
//
//   switch(numOfMonth) {
//     case 0:
//       returnMonth = "JAN";
//     case 1:
//       returnMonth = "FEB";
//     case 2:
//       returnMonth = "MAR";
//     case 3:
//       returnMonth = "APR";
//     case 4:
//       returnMonth = "MAY";
//     case 5:
//       returnMonth = "JUN";
//     case 6:
//       returnMonth = "JUL";
//     case 7:
//       returnMonth = "AUG";
//     case 8:
//       returnMonth = "SEP";
//     case 9:
//       returnMonth = "OCT";
//     case 10:
//       returnMonth = "NOV";
//     case 11:
//       returnMonth = "DEC";
//   }
//
//   return returnMonth;
// }
