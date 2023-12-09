import 'package:flutter/material.dart';
import 'package:icalendar_parser/icalendar_parser.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

class ICalViewer extends StatefulWidget {
  const ICalViewer({super.key});

  @override
  State<ICalViewer> createState() => _ICalViewerState();
}


class _ICalViewerState extends State<ICalViewer> {
  String ICAL = "EMPTY";
  final myController = TextEditingController();
  String iCalLink = "Insert ICal Link";


  @override
  void setCalendar() async {

    try {
      final response = await http.get(Uri.parse(myController.text));

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
  
  @override
  Widget build(BuildContext context) {



    return Scaffold(

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Text(ICAL),
              ),
            ),
            Card(
              child: Column(
                children: [

                  TextField(
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      hintText: iCalLink,
                    ),
                    controller: myController
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState((){
                        setCalendar();
                      });
                    },
                    child: const Text('Submit'),
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}
