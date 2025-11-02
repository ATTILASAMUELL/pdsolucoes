class ReportEntity {
  final String id;
  final String description;
  final DateTime date;
  final int hours;
  final String employeeId;
  final String employeeName;
  final String squadId;
  final String squadName;
  final DateTime createdAt;
  final DateTime updatedAt;

  ReportEntity({
    required this.id,
    required this.description,
    required this.date,
    required this.hours,
    required this.employeeId,
    required this.employeeName,
    required this.squadId,
    required this.squadName,
    required this.createdAt,
    required this.updatedAt,
  });
}

