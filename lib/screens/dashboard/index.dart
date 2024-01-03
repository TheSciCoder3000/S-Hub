import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:s_hub/models/event.dart';
import 'package:draggable_home/draggable_home.dart';
import 'package:s_hub/screens/dashboard/card_collection.dart';
import 'package:s_hub/screens/dashboard/todo_item.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _Dashboard();
}

class _Dashboard extends State<Dashboard> {

  String _selectedCollection = "All";


  List<Event> _getEventsForDay(DateTime day) {
    // Implementation example
    EventState eventState = context.read<EventState>();
    return eventState.eventMap[day] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    EventState eventState = context.watch<EventState>();
    DateTime selectedDay = eventState.selectedDay;
    List<Event> events = eventState.eventMap[selectedDay] ?? [];
    List<Event> totalEvents = [];
    DateFormat format = DateFormat("MMMM dd, yyyy");


    for (var event in eventState.eventMap.values) {
      totalEvents.addAll(event);
    }

    List<String> getCollections() {
      List<String> collection = ["All", "Unfinished", "Completed"];
      List<Event>? nowEvents = eventState.eventMap[selectedDay];

      if (nowEvents == null) return [];

      for (var event in nowEvents) {
        if (!collection.contains(event.categroy)) {
          collection.add(event.categroy);
        }
      }

      return collection;
    }

    return DraggableHome(
      headerExpandedHeight: 0.55,
      title: const Text("Todo List"),
      actions: [
        // TODO: add event handler here
        IconButton(onPressed: () {}, icon: const Icon(Icons.settings)),
      ],
      headerWidget: headerWidget(
        context, 
        getCollections(), 
        events,
        totalEvents
      ),
      body: [
        Text(
          DateUtils.dateOnly(selectedDay) == DateUtils.dateOnly(DateTime.now()) ? "EVENTS FOR TODAY" : format.format(selectedDay), 
          style: const TextStyle(
            color: Colors.white, 
            fontWeight: FontWeight.bold, 
            fontStyle: FontStyle.italic
          ),
        ),
        listView(events),
      ],
      backgroundColor: const Color.fromARGB(255, 50, 50, 50),
      appBarColor: const Color.fromARGB(255, 0, 221, 103),
    );
  }


  Widget headerWidget(BuildContext context, List<String> collections, List<Event> nowEvents, List<Event> allEvents) {
    double width = MediaQuery.of(context).size.width;
    final controller = PageController(viewportFraction: 0.9, keepPage: true);

    return Container(
      width: width,
      height: 640,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(0.99, -0.10),
          end: Alignment(-0.99, 0.1),
          colors: [Color.fromARGB(255, 0, 169, 149), Color.fromARGB(255, 0, 211, 98)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40.0),
          const Padding(
            padding: EdgeInsets.fromLTRB(20.0, 0, 0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Welcome back", style: TextStyle(fontSize: 18.0, color: Colors.white)),
                Text("John Juvi De Villa", style: TextStyle(fontSize: 30.0, color: Colors.white)),
              ],
            ),
          ),
          const SizedBox(height: 10.0),
          Expanded(
            child: PageView.builder(
              controller: controller,
              itemCount: collections.length,
              onPageChanged: (indx) {
                setState(() {
                  _selectedCollection = collections[indx];
                });
              },
              itemBuilder: (context, indx) {
                final String collection = collections[indx];
                int tasks = 0;
                int totalTasks = 0;
                Color percentColor = Colors.green;
                Color containerColor = Colors.redAccent;

                switch (collection) {
                  case "All":
                    tasks = allEvents.where((event) => event.completed).length;
                    totalTasks = allEvents.length;
                    break;
                  case "Unfinished":
                    tasks = nowEvents.where((event) => !event.completed).length;
                    totalTasks = nowEvents.length;
                    percentColor = Colors.redAccent;
                    containerColor = Colors.green;
                    break;
                  case "Completed":
                    tasks = nowEvents.where((event) => event.completed).length;
                    totalTasks = nowEvents.length;
                    break;
                  default:
                    tasks = nowEvents.where((event) => event.categroy == collection && event.completed).length;
                    totalTasks = nowEvents.where((event) => event.categroy == collection).length;
                }


                return CardCollection(
                  name: collection,
                  totalTasks: totalTasks,
                  countTasks: tasks, 
                  percentColor: percentColor, 
                  containerColor: containerColor,
                );
              }, 
            ),
          ),
          const SizedBox(height: 20.0,),
          Center(
            child: SmoothPageIndicator(
              controller: controller, 
              count: collections.length,
              effect: const WormEffect(
                dotColor: Color.fromARGB(81, 119, 119, 119),
                activeDotColor: Color.fromARGB(255, 0, 211, 180)
              ),
            ),
          ),
          const SizedBox(height: 40.0,),
        ],
      )
    );
  }


  ListView listView(List<Event> events) {
    List<Event> eventsView = [];

    switch (_selectedCollection) {
      case "All":
        eventsView = events;
        break;
      case "Unfinished":
        eventsView = events.where((event) => !event.completed).toList();
        break;
      case "Completed":
        eventsView = events.where((event) => event.completed).toList();
        break;
      default:
        eventsView = events.where((event) => event.categroy == _selectedCollection).toList();
    }

    return ListView.builder(
      padding: const EdgeInsets.only(top: 0),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: eventsView.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {

        Event event = eventsView[index];
        String title = event.title.substring(0, event.title.indexOf(':'));
        String summary = event.title.substring(event.title.indexOf(':') + 2, event.title.length);

        return TodoItem(
          eventId: event.uid,
          checked: event.completed,
          dtend: event.dtend,
          title: title,
          summary: summary
        );


      }
    );
  }

}
