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
            child: const Text("To-Do: Today", style: TextStyle(color: Colors.white),),
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
          const SizedBox(height: 5.0),
          TextButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(
                  builder: (context) => const ICalViewer(),
                ))
                  .then((value) {
                  setState(() {
                    _selectedDay = DateTime(kToday.year, kToday.month , kToday.day);
                    _selectedEvents.value = _getEventsForDay(_selectedDay!);
                  });
                });
              },
              child: const Text('Full Calendar', style: TextStyle(color: Colors.greenAccent),)
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
              addEvent(kToday, result[0], result[1]);
            });
            _selectedEvents.value = _getEventsForDay(kToday);
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