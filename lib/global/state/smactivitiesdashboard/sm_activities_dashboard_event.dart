// Required parameters: mode, EmployeeID, ActivityID, CurrentDate
abstract class SMActivitiesDashboardEvent {
  final String employeeID;
  final String activityID;

  SMActivitiesDashboardEvent({
    required this.employeeID,
    required this.activityID,
  });
}

class SaveSMActivitiesDashboard extends SMActivitiesDashboardEvent {
  SaveSMActivitiesDashboard({
    required super.employeeID,
    required super.activityID,
  });
}

class DeleteSMActivitiesDashboard extends SMActivitiesDashboardEvent {
  final String date;

  DeleteSMActivitiesDashboard({
    required super.employeeID,
    required super.activityID,
    required this.date,
  });
}
