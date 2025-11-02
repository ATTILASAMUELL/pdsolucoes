import 'package:pdsolucoes_front_end/domain/entities/report_entity.dart';
import 'package:pdsolucoes_front_end/domain/repositories/report_repository.dart';

class GetAllReportsUseCase {
  final ReportRepository repository;

  GetAllReportsUseCase(this.repository);

  Future<List<ReportEntity>> call() async {
    return await repository.getAllReports();
  }
}

