import 'package:pdsolucoes_front_end/domain/repositories/employee_repository.dart';
import 'package:pdsolucoes_front_end/domain/entities/employee_entity.dart';

class GetAllEmployeesUseCase {
  final EmployeeRepository repository;

  GetAllEmployeesUseCase(this.repository);

  Future<List<EmployeeEntity>> call({String? search}) async {
    return await repository.getAllEmployees(search: search);
  }
}
