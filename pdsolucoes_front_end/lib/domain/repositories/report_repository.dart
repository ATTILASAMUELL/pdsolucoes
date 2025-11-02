import 'package:pdsolucoes_front_end/domain/entities/report_entity.dart';
import 'package:pdsolucoes_front_end/domain/entities/member_hours_entity.dart';
import 'package:pdsolucoes_front_end/domain/entities/total_hours_entity.dart';
import 'package:pdsolucoes_front_end/domain/entities/average_hours_entity.dart';
import 'package:pdsolucoes_front_end/domain/entities/dashboard_entity.dart';

abstract class ReportRepository {
  Future<List<ReportEntity>> getAllReports();

  Future<ReportEntity> createReport({
    required String description,
    required DateTime date,
    required int hours,
    required String employeeId,
  });

  Future<List<MemberHoursEntity>> getSquadMemberHours({
    required String squadId,
    DateTime? startDate,
    DateTime? endDate,
  });

  Future<TotalHoursEntity> getSquadTotalHours({
    required String squadId,
    DateTime? startDate,
    DateTime? endDate,
  });

  Future<AverageHoursEntity> getSquadAverageHours({
    required String squadId,
    DateTime? startDate,
    DateTime? endDate,
  });

  Future<DashboardEntity> getDashboard({
    DateTime? startDate,
    DateTime? endDate,
  });
}

