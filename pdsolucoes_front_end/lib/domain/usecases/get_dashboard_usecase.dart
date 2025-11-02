import 'package:pdsolucoes_front_end/domain/entities/dashboard_entity.dart';
import 'package:pdsolucoes_front_end/domain/repositories/report_repository.dart';

class GetDashboardUseCase {
  final ReportRepository repository;

  GetDashboardUseCase(this.repository);

  Future<DashboardEntity> call({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    return await repository.getDashboard(
      startDate: startDate,
      endDate: endDate,
    );
  }
}

