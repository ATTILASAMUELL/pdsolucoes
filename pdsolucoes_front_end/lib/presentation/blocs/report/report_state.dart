import 'package:pdsolucoes_front_end/domain/entities/report_entity.dart';
import 'package:pdsolucoes_front_end/domain/entities/dashboard_entity.dart';
import 'package:pdsolucoes_front_end/domain/entities/member_hours_entity.dart';
import 'package:pdsolucoes_front_end/domain/entities/total_hours_entity.dart';
import 'package:pdsolucoes_front_end/domain/entities/average_hours_entity.dart';

abstract class ReportState {}

class ReportInitial extends ReportState {}

class ReportLoading extends ReportState {}

class ReportCreating extends ReportState {}

class ReportCreated extends ReportState {
  final ReportEntity report;

  ReportCreated({required this.report});
}

class ReportsLoaded extends ReportState {
  final List<ReportEntity> reports;

  ReportsLoaded({required this.reports});
}

class DashboardLoaded extends ReportState {
  final DashboardEntity dashboard;

  DashboardLoaded({required this.dashboard});
}

class MemberHoursLoaded extends ReportState {
  final List<MemberHoursEntity> memberHours;

  MemberHoursLoaded({required this.memberHours});
}

class TotalHoursLoaded extends ReportState {
  final TotalHoursEntity totalHours;

  TotalHoursLoaded({required this.totalHours});
}

class AverageHoursLoaded extends ReportState {
  final AverageHoursEntity averageHours;

  AverageHoursLoaded({required this.averageHours});
}

class ReportError extends ReportState {
  final String message;

  ReportError({required this.message});
}

