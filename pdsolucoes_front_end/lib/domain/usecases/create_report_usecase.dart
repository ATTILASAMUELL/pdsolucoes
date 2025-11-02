import 'package:pdsolucoes_front_end/domain/entities/report_entity.dart';
import 'package:pdsolucoes_front_end/domain/repositories/report_repository.dart';

class CreateReportUseCase {
  final ReportRepository repository;

  CreateReportUseCase(this.repository);

  Future<ReportEntity> call({
    required String description,
    required DateTime date,
    required int hours,
    required String employeeId,
  }) async {
    return await repository.createReport(
      description: description,
      date: date,
      hours: hours,
      employeeId: employeeId,
    );
  }
}

