abstract class EmployeeEvent {}

class LoadEmployeesEvent extends EmployeeEvent {
  final String? search;
  final bool isInitialLoad;

  LoadEmployeesEvent({this.search, this.isInitialLoad = false});
}

class CreateEmployeeEvent extends EmployeeEvent {
  final String name;
  final int estimatedHours;
  final String squadId;

  CreateEmployeeEvent({
    required this.name,
    required this.estimatedHours,
    required this.squadId,
  });
}


