import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:s_hub/models/event.dart';
import 'package:s_hub/screens/calendar/todo_list.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:s_hub/utils/utils.dart';


class ICalViewer extends StatefulWidget {
  const ICalViewer({super.key});

  @override
  State<ICalViewer> createState() => _ICalViewerState();
}


class _ICalViewerState extends State<ICalViewer> {
  final courseController = TextEditingController();
  final summaryController = TextEditingController();
  final myController = TextEditingController();
  late final ValueNotifier<List<Event>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOff; // Can be toggled on/off by longpressing a date
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  String selectedOption = "AssignmentEvent";


  @override
  void initState() {
    super.initState();

    _selectedDay = DateTime(kToday.year, kToday.month , kToday.day);
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<EventState>().setSelectedDay(DateTime(kToday.year, kToday.month , kToday.day));
    });

  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  List<Event> _getEventsForDay(DateTime day) {
    // Implementation example
    EventState eventState = context.read<EventState>();
    return eventState.eventMap[day] ?? [];
  }

  List<Event> _getEventsForRange(DateTime start, DateTime end) {
    // Implementation example
    final days = daysInRange(start, end);

    return [
      for (final d in days) ..._getEventsForDay(d),
    ];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    EventState eventState = context.read<EventState>();
    
    eventState.setSelectedDay(selectedDay);

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
    EventState eventState = context.watch<EventState>();
    List<Event> events = eventState.eventMap[eventState.selectedDay] ?? [];
    
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
          const SizedBox(height: 30.0),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 50, 50, 50),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30),
                  topLeft: Radius.circular(30)
                )
              ),
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              child: ListView.builder(
                itemCount: events.length,
                itemBuilder: (context, index) {
                  String summary = "";
          
                  Event event = events[index];
            
                  if (event.toString()[0] == '|') {
                    String str = event.toString();
                    summary = str.substring(1, str.length);
                  } else {
                    String str = event.toString();
                    summary = str.substring(0, str.length);
                  }
            
                  return CalendarTodoList(
                    eventId: event.uid, 
                    summary: summary, 
                    dtend: event.dtend,
                    checked: event.completed,
                  );
            
                },
              ),
            )
            
          ),
        ],
      ),
    );
  }

}


