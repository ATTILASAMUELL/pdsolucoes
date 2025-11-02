import 'package:pdsolucoes_front_end/domain/repositories/employee_repository.dart';
import 'package:pdsolucoes_front_end/domain/entities/employee_entity.dart';
import 'package:pdsolucoes_front_end/data/datasources/employee_remote_datasource.dart';

class EmployeeRepositoryImpl implements EmployeeRepository {
  final EmployeeRemoteDataSource _remoteDataSource;

  EmployeeRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<EmployeeEntity>> getAllEmployees({String? search}) async {
    try {
      final employees = await _remoteDataSource.getAllEmployees(search: search);
      return employees;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<EmployeeEntity> createEmployee({
    required String name,
    required int estimatedHours,
    required String squadId,
  }) async {
    try {
      return await _remoteDataSource.createEmployee(
        name: name,
        estimatedHours: estimatedHours,
        squadId: squadId,
      );
    } catch (e) {
      rethrow;
    }
  }
}
