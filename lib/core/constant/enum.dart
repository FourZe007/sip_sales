enum DashboardType {
  none,
  salesman,
  followup,
  spk, // accessible only for head store
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
  deleteManagerActivity, // for delete manager activity
  logout, // for logout
  leasing, // for SPK leasing filter
}

enum StatusCode {
  success(100),
  noContent(204),
  notFound(404);

  final int value;

  const StatusCode(this.value);
}

enum NavbarType {
  home,
  report,
  profile,
}

enum HeadSlidingPanel {
  delete, // for delete manager activity
  logout, // for logout
}
