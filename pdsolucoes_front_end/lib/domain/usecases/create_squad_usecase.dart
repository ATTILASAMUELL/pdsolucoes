import 'package:pdsolucoes_front_end/domain/repositories/squad_repository.dart';
import 'package:pdsolucoes_front_end/domain/entities/squad_entity.dart';

class CreateSquadUseCase {
  final SquadRepository repository;

  CreateSquadUseCase(this.repository);

  Future<SquadEntity> call({required String name}) async {
    if (name.isEmpty) {
      throw Exception('Nome é obrigatório');
    }

    return await repository.createSquad(name: name);
  }
}


