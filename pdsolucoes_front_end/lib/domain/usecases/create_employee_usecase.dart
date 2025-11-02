import 'package:pdsolucoes_front_end/domain/repositories/employee_repository.dart';
import 'package:pdsolucoes_front_end/domain/entities/employee_entity.dart';

class CreateEmployeeUseCase {
  final EmployeeRepository repository;

  CreateEmployeeUseCase(this.repository);

  Future<EmployeeEntity> call({
    required String name,
    required int estimatedHours,
    required String squadId,
  }) async {
    if (name.isEmpty) {
      throw Exception('Nome é obrigatório');
    }

    if (estimatedHours < 1 || estimatedHours > 12) {
      throw Exception('Horas estimadas devem estar entre 1 e 12');
    }

    if (squadId.isEmpty) {
      throw Exception('Squad é obrigatória');
    }

    return await repository.createEmployee(
      name: name,
      estimatedHours: estimatedHours,
      squadId: squadId,
    );
  }
}


