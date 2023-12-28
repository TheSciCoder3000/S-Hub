import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:s_hub/models/event.dart';
import 'package:s_hub/models/user.dart';
import 'package:s_hub/utils/firebase/db.dart';

class CalendarTodoList extends StatefulWidget {
  const CalendarTodoList({
    super.key, 
    required this.eventId, 
    required this.summary, 
    required this.checked,
    this.dtend, 
  });
  final String summary;
  final bool checked;
  final String eventId;
  final String? dtend;

  @override
  State<CalendarTodoList> createState() => _CalendarTodoListState();
}

class _CalendarTodoListState extends State<CalendarTodoList> {

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
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
            title: Text(
              widget.summary, 
              style: TextStyle(
                color: widget.checked ? Colors.white24 : Colors.white
              )
            ),
            tileColor: Colors.black12,
          ),
        );
  }

}