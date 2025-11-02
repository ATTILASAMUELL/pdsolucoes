import 'package:pdsolucoes_front_end/domain/entities/employee_entity.dart';

abstract class EmployeeState {}

class EmployeeInitial extends EmployeeState {}

class EmployeeLoading extends EmployeeState {}

class EmployeeSearching extends EmployeeState {
  final List<EmployeeEntity> currentEmployees;

  EmployeeSearching({required this.currentEmployees});
}

class EmployeeLoaded extends EmployeeState {
  final List<EmployeeEntity> employees;

  EmployeeLoaded({required this.employees});
}

class EmployeeCreating extends EmployeeState {}

class EmployeeCreated extends EmployeeState {
  final EmployeeEntity employee;

  EmployeeCreated({required this.employee});
}

class EmployeeError extends EmployeeState {
  final String message;

  EmployeeError({required this.message});
}
