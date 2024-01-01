import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:s_hub/utils/ical.dart';

class CreateModal extends StatefulWidget {
  const CreateModal({super.key, required this.selectedDay});
  final DateTime selectedDay;

  @override
  State<CreateModal> createState() => _CreateModalState();
}

class _CreateModalState extends State<CreateModal> {
  final courseController = TextEditingController();
  final summaryController = TextEditingController();
  String eventOption = EventCategories.classEvent.value;
  late DateTime selectedDay;

  @override
  void initState() {
    super.initState();
    selectedDay = widget.selectedDay;
  }

  TextStyle mainTextStyle({
    double? fontSize, 
    Color color = Colors.white60
  }) => TextStyle(
    color: color,
    fontSize: fontSize
  );

  @override
  Widget build(BuildContext context) {
    const Color buttonColor = Color.fromARGB(255, 0, 174, 116);
    DateFormat format = DateFormat("MMMM dd, yyyy");

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 70.0, horizontal: 20.0),
      child: Container(
        color: const Color.fromARGB(255, 20, 20, 20),
        child:  Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Add New Event", style: mainTextStyle(fontSize: 38.0, color: Colors.white)),
                const SizedBox(height: 15.0),
                Text(format.format(selectedDay), style: mainTextStyle(fontSize: 18)),
                const SizedBox(height: 40.0),
                TextField(
                  controller: courseController,
                  decoration: InputDecoration(
                    hintText: "Course", 
                    hintStyle: mainTextStyle(color: Colors.white30),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white38)
                    )
                  ),
                  style: mainTextStyle(),
                ),
                const SizedBox(height: 15.0),
                TextField(
                  controller: summaryController,
                  decoration: InputDecoration(
                    hintText: "Event Summary", 
                    hintStyle: mainTextStyle(color: Colors.white30),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white38)
                    )
                  ),
                  style: mainTextStyle(),
                ),
                const SizedBox(height: 15.0),
                DropdownButton(
                  style: mainTextStyle(),
                  dropdownColor: const Color.fromARGB(255, 40, 40, 40),
                  focusColor: const Color.fromARGB(255, 60, 60, 60),
                  value: eventOption,
                  icon: const Icon(Icons.arrow_drop_down),
                  items: [
                    DropdownMenuItem<String>(value: EventCategories.assignmentEvent.value, child: Text(EventCategories.assignmentEvent.display)),
                    DropdownMenuItem<String>(value: EventCategories.classEvent.value, child: Text(EventCategories.classEvent.display)),
                    DropdownMenuItem<String>(value: EventCategories.lessonEvent.value, child: Text(EventCategories.lessonEvent.display)),
                    DropdownMenuItem<String>(value: EventCategories.classStartEvent.value, child: Text(EventCategories.classStartEvent.display)),
                    DropdownMenuItem<String>(value: EventCategories.classFinishEvent.value, child: Text(EventCategories.classFinishEvent.display)),
                  ], 
                  onChanged: (optionValue) {
                    if (optionValue != null) {
                      setState(() { eventOption = optionValue;});
                    }
                  }
                ),
              ],
            ),
            const SizedBox(height: 50.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll<Color>(buttonColor)),
                  child: const Text("Cancel"),
                  onPressed: () => Navigator.pop(context),
                ),
                ElevatedButton(
                  style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll<Color>(buttonColor)),
                  child: const Text('OK'),
                  onPressed: () {
          
                    if (courseController.text != "" && summaryController.text != "" ) {
                      Navigator.pop(context, [courseController.text, summaryController.text, eventOption]);
                    } else {
                      Navigator.pop(context);
                    }
          
                  }
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}