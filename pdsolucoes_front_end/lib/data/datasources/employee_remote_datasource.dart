import 'package:dio/dio.dart';
import 'package:pdsolucoes_front_end/core/network/dio_client.dart';
import 'package:pdsolucoes_front_end/core/constants/api_endpoints.dart';
import 'package:pdsolucoes_front_end/data/models/employee_model.dart';

class EmployeeRemoteDataSource {
  final Dio _dio = DioClient.instance.dio;

  Future<List<EmployeeModel>> getAllEmployees({String? search}) async {
    try {
      print('🔍 Buscando employees...');
      print('🔑 Headers: ${_dio.options.headers}');

      final queryParams = <String, dynamic>{};
      if (search != null && search.isNotEmpty) {
        queryParams['search'] = search;
      }

      final response = await _dio.get(
        ApiEndpoints.getAllEmployees,
        queryParameters: queryParams,
      );

      print('✅ Employees recebidos: ${response.data}');

      final List<dynamic> data = response.data['data'] ?? [];
      return data.map((json) => EmployeeModel.fromJson(json)).toList();
    } on DioError catch (e) {
      print('❌ Erro ao buscar employees: ${e.response?.statusCode}');
      print('❌ Mensagem: ${e.response?.data}');
      if (e.response != null) {
        final message = e.response?.data['message'] ?? 'Erro ao buscar employees';
        throw Exception(message);
      }
      throw Exception('Erro de conexão. Verifique sua internet.');
    } catch (e) {
      throw Exception('Erro inesperado: ${e.toString()}');
    }
  }

  Future<EmployeeModel> createEmployee({
    required String name,
    required int estimatedHours,
    required String squadId,
  }) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.createEmployee,
        data: {
          'name': name,
          'estimatedHours': estimatedHours,
          'squadId': squadId,
        },
      );

      return EmployeeModel.fromJson(response.data['data']);
    } on DioError catch (e) {
      if (e.response != null) {
        final message = e.response?.data['message'] ?? 'Erro ao criar employee';
        throw Exception(message);
      }
      throw Exception('Erro de conexão. Verifique sua internet.');
    } catch (e) {
      throw Exception('Erro inesperado: ${e.toString()}');
    }
  }
}

