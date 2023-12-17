import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
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

    setCalendar();

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
    setState(() {});
    return Scaffold(

      body: Column(
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
            calendarStyle: CalendarStyle(
              // Use `CalendarStyle` to customize the UI
              outsideDaysVisible: false,
            ),
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
                    return Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 4.0,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: ListTile(
                        onTap: () => print('${value[index]}'),
                        title: Text('${value[index]}'),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _CalendarHeader extends StatelessWidget {
  final DateTime focusedDay;
  final VoidCallback onLeftArrowTap;
  final VoidCallback onRightArrowTap;
  final VoidCallback onTodayButtonTap;
  final VoidCallback onClearButtonTap;
  final bool clearButtonVisible;

  const _CalendarHeader({
    Key? key,
    required this.focusedDay,
    required this.onLeftArrowTap,
    required this.onRightArrowTap,
    required this.onTodayButtonTap,
    required this.onClearButtonTap,
    required this.clearButtonVisible,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final headerText = DateFormat.yMMM().format(focusedDay);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          const SizedBox(width: 16.0),
          SizedBox(
            width: 120.0,
            child: Text(
              headerText,
              style: TextStyle(fontSize: 26.0),
            ),
          ),
          IconButton(
            icon: Icon(Icons.calendar_today, size: 20.0),
            visualDensity: VisualDensity.compact,
            onPressed: onTodayButtonTap,
          ),
          if (clearButtonVisible)
            IconButton(
              icon: Icon(Icons.clear, size: 20.0),
              visualDensity: VisualDensity.compact,
              onPressed: onClearButtonTap,
            ),
          const Spacer(),
          IconButton(
            icon: Icon(Icons.chevron_left),
            onPressed: onLeftArrowTap,
          ),
          IconButton(
            icon: Icon(Icons.chevron_right),
            onPressed: onRightArrowTap,
          ),
        ],
      ),
    );
  }
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
