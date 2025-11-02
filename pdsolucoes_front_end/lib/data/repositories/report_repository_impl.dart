import 'package:pdsolucoes_front_end/data/datasources/report_remote_datasource.dart';
import 'package:pdsolucoes_front_end/domain/repositories/report_repository.dart';
import 'package:pdsolucoes_front_end/domain/entities/report_entity.dart';
import 'package:pdsolucoes_front_end/domain/entities/member_hours_entity.dart';
import 'package:pdsolucoes_front_end/domain/entities/total_hours_entity.dart';
import 'package:pdsolucoes_front_end/domain/entities/average_hours_entity.dart';
import 'package:pdsolucoes_front_end/domain/entities/dashboard_entity.dart';

class ReportRepositoryImpl implements ReportRepository {
  final ReportRemoteDataSource _remoteDataSource;

  ReportRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<ReportEntity>> getAllReports() async {
    try {
      final models = await _remoteDataSource.getAllReports();
      return models.map((model) => model.toEntity()).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ReportEntity> createReport({
    required String description,
    required DateTime date,
    required int hours,
    required String employeeId,
  }) async {
    try {
      final model = await _remoteDataSource.createReport(
        description: description,
        date: date,
        hours: hours,
        employeeId: employeeId,
      );
      return model.toEntity();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<MemberHoursEntity>> getSquadMemberHours({
    required String squadId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final models = await _remoteDataSource.getSquadMemberHours(
        squadId: squadId,
        startDate: startDate,
        endDate: endDate,
      );
      return models.map((model) => model.toEntity()).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<TotalHoursEntity> getSquadTotalHours({
    required String squadId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final model = await _remoteDataSource.getSquadTotalHours(
        squadId: squadId,
        startDate: startDate,
        endDate: endDate,
      );
      return model.toEntity();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<AverageHoursEntity> getSquadAverageHours({
    required String squadId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final model = await _remoteDataSource.getSquadAverageHours(
        squadId: squadId,
        startDate: startDate,
        endDate: endDate,
      );
      return model.toEntity();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<DashboardEntity> getDashboard({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final model = await _remoteDataSource.getDashboard(
        startDate: startDate,
        endDate: endDate,
      );
      return model.toEntity();
    } catch (e) {
      rethrow;
    }
  }
}

