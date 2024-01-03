import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:s_hub/models/event.dart';
import 'package:s_hub/models/user.dart';
import 'package:s_hub/utils/firebase/db.dart';

class TodoItem extends StatefulWidget {
  const TodoItem({super.key, required this.eventId, required this.checked, required this.dtend, required this.title, required this.summary});
  final String eventId;
  final bool checked;
  final String? dtend;
  final String title;
  final String summary;

  @override
  State<TodoItem> createState() => _TodoItemState();
}

class _TodoItemState extends State<TodoItem> {

  void _updateEventState(String uid, String dtend) {
    DateTime stateKey = DateUtils.dateOnly(DateTime.parse(dtend));

    context.read<EventState>().setEventState(
      stateKey, 
      widget.eventId, 
      !widget.checked
    );

    FirestoreService(uid: uid).updateEventStatus(widget.eventId, !widget.checked);
  }
  
  void _deleteEvent(String uid, String eventId, DateTime key) {
    FirestoreService(uid: uid).deleteEvent(eventId);

    context.read<EventState>().deleteEvent(key, eventId);
  }
  
  @override
  Widget build(BuildContext context) {
    String? uid = context.select<SUser, String?>((model) => model.uid);

    return Dismissible(
      key: Key("${widget.eventId}-${widget.checked}"),
      confirmDismiss: (direction) async {
        String? dtend = widget.dtend; 
        if (dtend == null) return false;

        if (direction == DismissDirection.startToEnd) {
          _updateEventState(uid!, dtend);
        } else {
          _deleteEvent(uid!, widget.eventId, DateUtils.dateOnly(DateTime.parse(dtend)));
        }

        return false;
      },
      background: Container(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      color: widget.checked ? Colors.orange : Colors.green,
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          const Icon(Icons.check, color: Colors.white),
          const SizedBox(width: 10.0),
          Text(widget.checked ? "unfinished" : "Completed", style: const TextStyle(color: Colors.white),)
        ],
      ),
    ),
    secondaryBackground: Container(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      color: Colors.red,
      alignment: Alignment.centerRight,
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text("Trash", style: TextStyle(color: Colors.white)),
          SizedBox(width: 10.0,),
          Icon(Icons.delete, color: Colors.white),
        ],
      ),
    ),
      child: Card(
        color: Colors.black,
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: widget.checked ? Colors.greenAccent : Colors.orangeAccent,
            radius: 10,
          ),
          title: Text(widget.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),),
          subtitle: Row(
            children: [
              const SizedBox(width: 13),
              Flexible(child: Text(widget.summary, style: const TextStyle(color: Colors.white),))
            ],
          ),
          minVerticalPadding: 15,
        ),
      ),
    );
  }
}