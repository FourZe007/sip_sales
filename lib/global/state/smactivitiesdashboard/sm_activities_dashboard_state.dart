abstract class SMActivitiesDashboardState {}

class SMActivitiesDashboardInit extends SMActivitiesDashboardState {}

// ~:Saving required parameters for deleting certain report success:~
// Requried parameters: mode, EmployeeID, ActivityID, CurrentDate
class SMActivitiesDashboardSaved extends SMActivitiesDashboardState {
  final String employeeID;
  final String activityID;

  SMActivitiesDashboardSaved({
    required this.employeeID,
    required this.activityID,
  });
}

// ~:Saving required parameters for deleting certain report failed:~
class SMActivitiesDashboardError extends SMActivitiesDashboardState {
  final String message;

  SMActivitiesDashboardError(this.message);
}

// ~:Initiate loading state for deleting certain report:~
class SMActivitiesDashboardLoading extends SMActivitiesDashboardState {}

// ~:Certain report successfully deleted:~
class SMActivitiesDashboardDeleted extends SMActivitiesDashboardState {}

// ~:Certain report failed to delete:~
class SMActivitiesDashboardDeletedFailed extends SMActivitiesDashboardState {
  final String message;

  SMActivitiesDashboardDeletedFailed(this.message);
}
