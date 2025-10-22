import 'package:geolocator/geolocator.dart';
import 'package:sip_sales_clean/data/models/employee.dart';

abstract class AttendanceEvent {}

class DailyAttendance extends AttendanceEvent {
  final EmployeeModel employee;
  final String date;
  final String time;
  final Position coordinate;

  DailyAttendance({
    required this.employee,
    required this.date,
    required this.time,
    required this.coordinate,
  });
}

class EventAttendance extends AttendanceEvent {
  final EmployeeModel employee;
  final String date;
  final String time;
  final String eventDesc;
  final String image;
  final Position coordinate;

  EventAttendance({
    required this.employee,
    required this.date,
    required this.time,
    required this.eventDesc,
    required this.image,
    required this.coordinate,
  });
}
