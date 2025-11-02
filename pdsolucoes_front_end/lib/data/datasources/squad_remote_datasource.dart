import 'package:dio/dio.dart';
import 'package:pdsolucoes_front_end/core/network/dio_client.dart';
import 'package:pdsolucoes_front_end/core/constants/api_endpoints.dart';
import 'package:pdsolucoes_front_end/data/models/squad_model.dart';

class SquadRemoteDataSource {
  final Dio _dio = DioClient.instance.dio;

  Future<List<SquadModel>> getAllSquads({String? search}) async {
    try {
      final queryParams = <String, dynamic>{};
      if (search != null && search.isNotEmpty) {
        queryParams['search'] = search;
      }

      final response = await _dio.get(
        ApiEndpoints.getAllSquads,
        queryParameters: queryParams,
      );

      final List<dynamic> data = response.data['data'] ?? [];
      return data.map((json) => SquadModel.fromJson(json)).toList();
    } on DioError catch (e) {
      if (e.response != null) {
        final message = e.response?.data['message'] ?? 'Erro ao buscar squads';
        throw Exception(message);
      }
      throw Exception('Erro de conexão. Verifique sua internet.');
    } catch (e) {
      throw Exception('Erro inesperado: ${e.toString()}');
    }
  }

  Future<SquadModel> createSquad({required String name}) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.createSquad,
        data: {'name': name},
      );

      return SquadModel.fromJson(response.data['data']);
    } on DioError catch (e) {
      if (e.response != null) {
        final message = e.response?.data['message'] ?? 'Erro ao criar squad';
        throw Exception(message);
      }
      throw Exception('Erro de conexão. Verifique sua internet.');
    } catch (e) {
      throw Exception('Erro inesperado: ${e.toString()}');
    }
  }
}


