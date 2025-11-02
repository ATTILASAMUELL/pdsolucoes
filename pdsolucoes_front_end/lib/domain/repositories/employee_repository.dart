import 'package:pdsolucoes_front_end/domain/entities/employee_entity.dart';

abstract class EmployeeRepository {
  Future<List<EmployeeEntity>> getAllEmployees({String? search});
  Future<EmployeeEntity> createEmployee({
    required String name,
    required int estimatedHours,
    required String squadId,
  });
}


