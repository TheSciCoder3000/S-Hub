import 'package:flutter/material.dart';
import 'package:icalendar_parser/icalendar_parser.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart';

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

    // var path = "/Links/ICAL.ics";
    // var dir = (await getApplicationDocumentsDirectory()).path;
    var path = "/storage/emulated/0/Download/ICAL.ics";
    var file = File(path);
    var res = await get(Uri.parse(myController.text));

    file.writeAsBytes(res.bodyBytes);

    final icsObj = ICalendar.fromLines( await File('/storage/emulated/0/Download/ICAL.ics').readAsLines());

    ICAL = jsonEncode(icsObj.toJson());
    print(jsonEncode(icsObj.toJson()));
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
