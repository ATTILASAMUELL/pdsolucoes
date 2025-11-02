abstract class ReportEvent {}

class LoadAllReportsEvent extends ReportEvent {}

class CreateReportEvent extends ReportEvent {
  final String description;
  final DateTime date;
  final int hours;
  final String employeeId;

  CreateReportEvent({
    required this.description,
    required this.date,
    required this.hours,
    required this.employeeId,
  });
}

class LoadDashboardEvent extends ReportEvent {
  final DateTime? startDate;
  final DateTime? endDate;

  LoadDashboardEvent({this.startDate, this.endDate});
}

class LoadSquadMemberHoursEvent extends ReportEvent {
  final String squadId;
  final DateTime? startDate;
  final DateTime? endDate;

  LoadSquadMemberHoursEvent({
    required this.squadId,
    this.startDate,
    this.endDate,
  });
}

class LoadSquadTotalHoursEvent extends ReportEvent {
  final String squadId;
  final DateTime? startDate;
  final DateTime? endDate;

  LoadSquadTotalHoursEvent({
    required this.squadId,
    this.startDate,
    this.endDate,
  });
}

class LoadSquadAverageHoursEvent extends ReportEvent {
  final String squadId;
  final DateTime? startDate;
  final DateTime? endDate;

  LoadSquadAverageHoursEvent({
    required this.squadId,
    this.startDate,
    this.endDate,
  });
}

