abstract class AttendanceState {}

class AttendanceInitial extends AttendanceState {}

// ~:Daily Attendance State:~
class DailyAttendanceLoading extends AttendanceState {}

class DailyAttendanceSuccess extends AttendanceState {}

class DailyAttendanceError extends AttendanceState {
  final String message;

  DailyAttendanceError({required this.message});
}

// ~:Event Attendance State:~
class EventAttendanceLoading extends AttendanceState {}

class EventAttendanceSuccess extends AttendanceState {}

class EventAttendanceError extends AttendanceState {
  final String message;

  EventAttendanceError({required this.message});
}
