import 'package:pdsolucoes_front_end/domain/entities/squad_entity.dart';

abstract class SquadRepository {
  Future<List<SquadEntity>> getAllSquads({String? search});
  Future<SquadEntity> createSquad({required String name});
}
