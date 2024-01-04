import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:s_hub/utils/ical.dart';

class CardCollection extends StatelessWidget {
  const CardCollection({
    super.key, 
    required this.name, 
    required this.countTasks, 
    required this.totalTasks,
    required this.percentColor,
    required this.containerColor
  });
  final String name;
  final int totalTasks;
  final int countTasks;
  final Color percentColor;
  final Color containerColor;

  String getContainerName(String categoryName) {
    const categories = EventCategories.values;

    for (var category in categories) {
      if (category.value == categoryName) return category.display;
    }

    return categoryName;
  }

  Widget cardContainer({required double width, required Widget child}) {
    return SizedBox(
      width: width,
      child: Card(
        color: const Color.fromARGB(100, 0, 0, 0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0)
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05), 
                    blurRadius: 15,
                    spreadRadius: -5,
                    offset: const Offset(7, 8)
                  )
                ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 100.0, sigmaY: 100.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black.withOpacity(0.05), width: 1.0),
                  borderRadius: BorderRadius.circular(20.0),
                  color: const Color.fromARGB(100, 125, 125, 125)
                ),
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: child,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return cardContainer(
      width: width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            child: CircularPercentIndicator(
              radius: width*(0.185),
              startAngle: 140,
              percent: countTasks / totalTasks,
              lineWidth: 10,
              center: Text(getContainerName(name), style: const TextStyle(fontSize: 20.0)),
              progressColor: percentColor,
              backgroundColor: containerColor,
            ),
          ),
          // const SizedBox(width: 15.0),
          Flexible(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Flexible(
                      child: Text(countTasks.toString(), style: const TextStyle(fontSize: 30.0)),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 7.0),
                      child: Text(
                        " task ${name == "Unfinished" ? "unfinished" : "completed"}", 
                        style: const TextStyle(fontSize: 15.0)
                      ),
                    ),
                  ],
                ),
                Flexible(
                  child: Text(
                    "${totalTasks-countTasks} tasks remaining", 
                    style: const TextStyle(fontSize: 11.0, color: Color.fromARGB(255, 218, 218, 218))
                  )
                )
              ],
            ),
          )
        ],
      )
    );
  }
}