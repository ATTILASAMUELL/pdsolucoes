import 'package:pdsolucoes_front_end/domain/entities/employee_entity.dart';

class EmployeeModel extends EmployeeEntity {
  EmployeeModel({
    required String id,
    required String name,
    required int estimatedHours,
    required String squadId,
    String? squadName,
    required DateTime createdAt,
  }) : super(
          id: id,
          name: name,
          estimatedHours: estimatedHours,
          squadId: squadId,
          squadName: squadName,
          createdAt: createdAt,
        );

  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    return EmployeeModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      estimatedHours: json['estimatedHours'] ?? 0,
      squadId: json['squadId'] ?? '',
      squadName: json['squad']?['name'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'estimatedHours': estimatedHours,
      'squadId': squadId,
    };
  }
}


