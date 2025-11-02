class EmployeeEntity {
  final String id;
  final String name;
  final int estimatedHours;
  final String squadId;
  final String? squadName;
  final DateTime createdAt;

  EmployeeEntity({
    required this.id,
    required this.name,
    required this.estimatedHours,
    required this.squadId,
    this.squadName,
    required this.createdAt,
  });
}


