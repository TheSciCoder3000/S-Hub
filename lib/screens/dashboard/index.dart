import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:s_hub/models/event.dart';
import 'package:draggable_home/draggable_home.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _Dashboard();
}

class _Dashboard extends State<Dashboard> {

  String _selectedCollection = "Assignment due";

  List<Event> _getEventsForDay(DateTime day) {
    // Implementation example
    EventState eventState = context.read<EventState>();
    return eventState.eventMap[day] ?? [];
  }

  @override
  // Widget build(BuildContext context) {
  //
  //   return Scaffold(
  //     body: Column(
  //       children: [
  //         const SizedBox(height: 70.0),
  //         Container(
  //           child: const Text("To-Do: Today", style: TextStyle(color: Colors.white),),
  //         ),
  //         const SizedBox(height: 20.0),
  //         Container(
  //           decoration: BoxDecoration(
  //               shape: BoxShape.rectangle,
  //               border: Border.all(color: Colors.white),
  //               borderRadius: BorderRadius.circular(12.0)
  //           ),
  //           height: 400,
  //           child: ValueListenableBuilder<List<Event>>(
  //             valueListenable: _selectedEvents,
  //             builder: (context, value, _) {
  //               return ListView.builder(
  //                 itemCount: value.length,
  //                 itemBuilder: (context, index) {
  //
  //                   Color color;
  //                   String summary = "";
  //
  //                   if (value[index].toString()[0] == '|') {
  //                     color = Colors.greenAccent;
  //                     String str = value[index].toString();
  //                     summary = str.substring(1, str.length);
  //                   } else {
  //                     color = Colors.white;
  //                     String str = value[index].toString();
  //                     summary = str.substring(0, str.length);
  //                   }
  //
  //                   return Container(
  //                     margin: const EdgeInsets.symmetric(
  //                       horizontal: 12.0,
  //                       vertical: 4.0,
  //                     ),
  //                     decoration: BoxDecoration(
  //                       border: Border.all(color: color),
  //                       borderRadius: BorderRadius.circular(12.0),
  //                     ),
  //                     child: ListTile(
  //                       onTap: () => print('${value[index]}'),
  //                       title: Text(summary, style: const TextStyle(color: Colors.white),),
  //                     ),
  //                   );
  //
  //                 },
  //               );
  //             },
  //           ),
  //         ),
  //         const SizedBox(height: 5.0),
  //         TextButton(
  //             onPressed: () {
  //               Navigator.of(context)
  //                   .push(MaterialPageRoute(
  //                 builder: (context) => const ICalViewer(),
  //               ))
  //                 .then((value) {
  //                 setState(() {
  //                   _selectedDay = DateTime(kToday.year, kToday.month , kToday.day);
  //                   _selectedEvents.value = _getEventsForDay(_selectedDay!);
  //                 });
  //               });
  //             },
  //             child: const Text('Full Calendar', style: TextStyle(color: Colors.greenAccent),)
  //         ),
  //
  //       ],
  //     ),
  //   );
  // }

  Widget build(BuildContext context) {
    EventState eventState = context.watch<EventState>();
    List<Event> events = eventState.eventMap[DateTime(2023, 12 , 16)] ?? [];

    List<String> getCollections() {
      List<String> collection = [];

      for (DateTime key in eventState.eventMap.keys) {
        for (final e in eventState.eventMap[key] ?? []) {
          String title = e.title;

          if (collection.contains(title.substring(0, title.indexOf(':'))) == false) {
            collection.add(title.substring(0, title.indexOf(':')));
          }
        }
      }

      return collection;
    }

    return DraggableHome(
      leading: const Icon(Icons.arrow_back_ios),
      title: const Text("Draggable Home"),
      // expandedBody: maximizedWidget(),
      actions: [
        IconButton(onPressed: () {}, icon: const Icon(Icons.settings)),
      ],
      headerWidget: headerWidget(getCollections(), events),
      body: [
        const Text("EVENTS FOR TODAY", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),),
        listView(events),
      ],
      backgroundColor: const Color.fromARGB(255, 50, 50, 50),
      appBarColor: Colors.black,
    );
  }

  // Container maximizedWidget() {
  //   return Container(
  //     color: Colors.black,
  //     child: Column(
  //       children: [
  //         const SizedBox(height: 70.0),
  //         Container(
  //           color: Colors.black,
  //           child: const Text("To-Do: Today", style: TextStyle(color: Colors.white),),
  //         ),
  //         const SizedBox(height: 20.0),
  //         Container(
  //           decoration: BoxDecoration(
  //               color: Colors.black,
  //               shape: BoxShape.rectangle,
  //               border: Border.all(color: Colors.white),
  //               borderRadius: BorderRadius.circular(12.0)
  //           ),
  //           height: 500,
  //           child: ValueListenableBuilder<List<Event>>(
  //             valueListenable: _selectedEvents,
  //             builder: (context, value, _) {
  //               return ListView.builder(
  //                 itemCount: value.length,
  //                 itemBuilder: (context, index) {
  //
  //                   Color color;
  //                   String summary = "";
  //
  //                   if (value[index].toString()[0] == '|') {
  //                     color = Colors.greenAccent;
  //                     String str = value[index].toString();
  //                     summary = str.substring(1, str.length);
  //                   } else {
  //                     color = Colors.white;
  //                     String str = value[index].toString();
  //                     summary = str.substring(0, str.length);
  //                   }
  //
  //                   return Container(
  //                     margin: const EdgeInsets.symmetric(
  //                       horizontal: 12.0,
  //                       vertical: 4.0,
  //                     ),
  //                     decoration: BoxDecoration(
  //                       border: Border.all(color: color),
  //                       borderRadius: BorderRadius.circular(12.0),
  //                     ),
  //                     child: ListTile(
  //                       onTap: () => print('${value[index]}'),
  //                       title: Text(summary, style: const TextStyle(color: Colors.white),),
  //                     ),
  //                   );
  //
  //                 },
  //               );
  //             },
  //           ),
  //         ),
  //
  //       ],
  //     ),
  //   );
  // }


  Widget headerWidget(collections, events) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: collections.length,
      itemBuilder: (context, index) {

        int count = 0;

        for (final i in events) {

          String group = i.title.substring(0, i.title.indexOf(':'));

          if (group == collections[index]) {count++;}
        }

        if (count > 0) {
          return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedCollection = collections[index];

                });
              },
              child: Container(
                color: Colors.black,
                child: Center(

                  child: SizedBox(
                    width: 170,
                    height: 170,
                    child: Card(
                      shape: RoundedRectangleBorder(
                          side: const BorderSide(
                            color: Colors.white,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(40)

                      ),
                      color: Colors.black,
                      child: ListTile(
                        title: Text(count.toString(), style: const TextStyle(fontWeight: FontWeight.w100,fontSize: 80, color: Colors.greenAccent, fontStyle: FontStyle.italic,)),
                        subtitle: Text(collections[index], style: const TextStyle(color: Colors.white, fontSize: 19)),
                      ),
                    ),
                  ),
                ),
              )
          );
        } else {
          return Container(width: 10, color: Colors.black,);
        }


      }
    );
  }


  ListView listView(events) {

    return ListView.builder(
      padding: const EdgeInsets.only(top: 0),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _getEventsForDay(DateTime(2023, 12 , 16)).length,
      shrinkWrap: true,
      itemBuilder: (context, index) {

        Event event = events[index];
        String title = event.title.substring(0, event.title.indexOf(':'));
        String summary = event.title.substring(event.title.indexOf(':') + 2, event.title.length);

        if (title == _selectedCollection) {
          return Card(
            color: Colors.black,
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.greenAccent,
                radius: 10,
              ),
              title: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),),
              subtitle: Row(
                children: [
                  const SizedBox(width: 13),
                  Flexible(child: Text(summary, style: const TextStyle(color: Colors.white),))
                ],
              ),
              minVerticalPadding: 15,
            ),
          );
        } else {
          return const SizedBox(height: 1);
        }


      }
    );
  }

}
