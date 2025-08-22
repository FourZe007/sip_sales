enum DashboardType {
  salesman,
  followup,
}

enum FollowUpStatus {
  notYet,
  inProgress,
  completed,
  cancelled,
}

enum FollowUpResults {
  pending,
  deal,
  cancel,
}

enum DashboardSlidingUpType {
  none,
  followupfilter, // for filter controls
  moreoption, // for each cards if needed in the future
}
