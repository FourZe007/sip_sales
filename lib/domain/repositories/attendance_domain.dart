import 'package:geolocator/geolocator.dart';
import 'package:sip_sales_clean/data/models/employee.dart';

abstract class AttendanceRepo {
  Future<Map<String, dynamic>> dailyAttendance(
    EmployeeModel employee,
    String date,
    String time,
    Position position,
  );

  Future<Map<String, dynamic>> eventAttendance(
    EmployeeModel employee,
    String date,
    String time,
    Position position,
    String eventDesc,
    String image,
  );
}
