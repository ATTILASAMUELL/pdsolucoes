import 'package:pdsolucoes_front_end/domain/repositories/squad_repository.dart';
import 'package:pdsolucoes_front_end/domain/entities/squad_entity.dart';
import 'package:pdsolucoes_front_end/data/datasources/squad_remote_datasource.dart';

class SquadRepositoryImpl implements SquadRepository {
  final SquadRemoteDataSource _remoteDataSource;

  SquadRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<SquadEntity>> getAllSquads({String? search}) async {
    try {
      final squads = await _remoteDataSource.getAllSquads(search: search);
      return squads;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<SquadEntity> createSquad({required String name}) async {
    try {
      return await _remoteDataSource.createSquad(name: name);
    } catch (e) {
      rethrow;
    }
  }
}
