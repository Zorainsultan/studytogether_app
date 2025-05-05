import 'package:flutter/material.dart';

// This function checks if the end time is after the start time.
bool isEndTimeAfterStartTime(TimeOfDay start, TimeOfDay end) {
  final startMinutes = start.hour * 60 + start.minute;
  final endMinutes = end.hour * 60 + end.minute;
  return endMinutes > startMinutes;
}

// This function returns the difference in minutes between start and end times.
int timeDifferenceInMinutes(TimeOfDay start, TimeOfDay end) {
  final startMinutes = start.hour * 60 + start.minute;
  final endMinutes = end.hour * 60 + end.minute;
  return endMinutes - startMinutes;
}
