enum EventCategories {
  assignmentEvent("AssignmentEvent", "Assignment"),
  classEvent("ClassEvent", "Class Event"),
  lessonEvent("LessonEvent", "Lesson Event"),
  classFinishEvent("ClassFinishEvent", "Class Finish"),
  classStartEvent("ClassStartEvent", "Class Start");

  const EventCategories(this.value, this.display);
  final String value;
  final String display;
}