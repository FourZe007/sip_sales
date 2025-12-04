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
  newManagerActivity, // for create new activity
  deleteManagerActivity, // for delete manager activity
  logout, // for logout
  // leasing, // for SPK leasing filter
  groupDealer,
  dealer,
  leasing,
  category,
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

enum FilterType { none, briefing, report, salesman }

enum StuType { stu, result, target, ach, lm, growth }

enum PaymentType { payment, result, target, growth }

enum LeasingType { leasing, spk, terbuka, disetujui, ditolak, approval }

enum SalesmanType { sales, position, spk, stu, stuLm }
