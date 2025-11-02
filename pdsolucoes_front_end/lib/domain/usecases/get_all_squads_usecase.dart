import 'package:pdsolucoes_front_end/domain/repositories/squad_repository.dart';
import 'package:pdsolucoes_front_end/domain/entities/squad_entity.dart';

class GetAllSquadsUseCase {
  final SquadRepository repository;

  GetAllSquadsUseCase(this.repository);

  Future<List<SquadEntity>> call({String? search}) async {
    return await repository.getAllSquads(search: search);
  }
}
