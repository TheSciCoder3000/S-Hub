import 'package:flutter/material.dart';
import 'package:s_hub/utils/utils.dart';
import 'package:s_hub/screens/dashboard/ical_viewer.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'dart:async';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _Dashboard();
}

class _Dashboard extends State<Dashboard> {
  late final ValueNotifier<List<Event>> _selectedEvents;

  DateTime? _selectedDay;
  bool initialized = false;

  _Dashboard() {
    setCalendar();
    Future.delayed(const Duration(seconds: 10), () {
      setState(() {
        _selectedDay = DateTime(kToday.year, kToday.month , kToday.day);
        _selectedEvents.value = _getEventsForDay(_selectedDay!);

      });
    });
  }

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

  @override
  Widget build(BuildContext context) {

    if (initialized == false) {
      Loader.show(
        context,
        progressIndicator: const CircularProgressIndicator(backgroundColor: Color.fromARGB(0, 33, 149, 243), color: Colors.greenAccent,),
        overlayColor: Colors.black26,
      );

      Future.delayed(const Duration(seconds: 10), () {
        Loader.hide();
      });
      initialized = true;
    }

    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 70.0),
          Container(
            child: Text("To-Do: Today", style: TextStyle(color: Colors.white),),
          ),
          const SizedBox(height: 20.0),
          Container(
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(12.0)
            ),
            height: 400,
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
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: ListTile(
                        onTap: () => print('${value[index]}'),
                        title: Text('${value[index]}', style: TextStyle(color: Colors.white),),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 5.0),
          TextButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const ICalViewer())
                );
              },
              child: const Text('Full Calendar', style: TextStyle(color: Colors.greenAccent),))
        ],
      ),
    );
  }

}