import 'package:pdsolucoes_front_end/domain/entities/squad_entity.dart';

class SquadModel extends SquadEntity {
  SquadModel({
    required String id,
    required String name,
    required DateTime createdAt,
  }) : super(
          id: id,
          name: name,
          createdAt: createdAt,
        );

  factory SquadModel.fromJson(Map<String, dynamic> json) {
    return SquadModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }
}


