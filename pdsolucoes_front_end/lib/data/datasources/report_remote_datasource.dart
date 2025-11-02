import 'package:dio/dio.dart';
import 'package:pdsolucoes_front_end/core/constants/api_endpoints.dart';
import 'package:pdsolucoes_front_end/core/network/dio_client.dart';
import 'package:pdsolucoes_front_end/data/models/report_model.dart';

class ReportRemoteDataSource {
  final Dio _dio = DioClient.instance.dio;

  Future<List<ReportModel>> getAllReports() async {
    try {
      final response = await _dio.get(ApiEndpoints.getAllReports);

      final List<dynamic> data = response.data['data'] ?? [];
      return data.map((json) => ReportModel.fromJson(json)).toList();
    } on DioError catch (e) {
      if (e.response != null) {
        final message =
            e.response?.data['message'] ?? 'Erro ao buscar reports';
        throw Exception(message);
      }
      throw Exception('Erro de conexão. Verifique sua internet.');
    } catch (e) {
      throw Exception('Erro inesperado: ${e.toString()}');
    }
  }

  Future<ReportModel> createReport({
    required String description,
    required DateTime date,
    required int hours,
    required String employeeId,
  }) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.createReport,
        data: {
          'description': description,
          'spentHours': hours,
          'employeeId': employeeId,
        },
      );
      return ReportModel.fromJson(response.data['data']);
    } on DioError catch (e) {
      if (e.response != null) {
        final message =
            e.response?.data['message'] ?? 'Erro ao criar report';
        throw Exception(message);
      }
      throw Exception('Erro de conexão. Verifique sua internet.');
    } catch (e) {
      throw Exception('Erro inesperado: ${e.toString()}');
    }
  }

  Future<List<MemberHoursModel>> getSquadMemberHours({
    required String squadId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (startDate != null) {
        queryParams['startDate'] = startDate.toIso8601String();
      }
      if (endDate != null) {
        queryParams['endDate'] = endDate.toIso8601String();
      }

      final response = await _dio.get(
        ApiEndpoints.getSquadMemberHours(squadId),
        queryParameters: queryParams,
      );

      final List<dynamic> data = response.data['data'] ?? [];
      return data.map((json) => MemberHoursModel.fromJson(json)).toList();
    } on DioError catch (e) {
      if (e.response != null) {
        final message = e.response?.data['message'] ??
            'Erro ao buscar horas dos membros';
        throw Exception(message);
      }
      throw Exception('Erro de conexão. Verifique sua internet.');
    } catch (e) {
      throw Exception('Erro inesperado: ${e.toString()}');
    }
  }

  Future<TotalHoursModel> getSquadTotalHours({
    required String squadId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (startDate != null) {
        queryParams['startDate'] = startDate.toIso8601String();
      }
      if (endDate != null) {
        queryParams['endDate'] = endDate.toIso8601String();
      }

      final response = await _dio.get(
        ApiEndpoints.getSquadTotalHours(squadId),
        queryParameters: queryParams,
      );

      return TotalHoursModel.fromJson(response.data['data']);
    } on DioError catch (e) {
      if (e.response != null) {
        final message = e.response?.data['message'] ??
            'Erro ao buscar total de horas';
        throw Exception(message);
      }
      throw Exception('Erro de conexão. Verifique sua internet.');
    } catch (e) {
      throw Exception('Erro inesperado: ${e.toString()}');
    }
  }

  Future<AverageHoursModel> getSquadAverageHours({
    required String squadId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (startDate != null) {
        queryParams['startDate'] = startDate.toIso8601String();
      }
      if (endDate != null) {
        queryParams['endDate'] = endDate.toIso8601String();
      }

      final response = await _dio.get(
        ApiEndpoints.getSquadAverageHours(squadId),
        queryParameters: queryParams,
      );

      return AverageHoursModel.fromJson(response.data['data']);
    } on DioError catch (e) {
      if (e.response != null) {
        final message = e.response?.data['message'] ??
            'Erro ao buscar média de horas';
        throw Exception(message);
      }
      throw Exception('Erro de conexão. Verifique sua internet.');
    } catch (e) {
      throw Exception('Erro inesperado: ${e.toString()}');
    }
  }

  Future<DashboardModel> getDashboard({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (startDate != null) {
        queryParams['startDate'] = startDate.toIso8601String();
      }
      if (endDate != null) {
        queryParams['endDate'] = endDate.toIso8601String();
      }

      final response = await _dio.get(
        ApiEndpoints.getDashboard,
        queryParameters: queryParams,
      );

      return DashboardModel.fromJson(response.data['data']);
    } on DioError catch (e) {
      if (e.response != null) {
        final message =
            e.response?.data['message'] ?? 'Erro ao buscar dashboard';
        throw Exception(message);
      }
      throw Exception('Erro de conexão. Verifique sua internet.');
    } catch (e) {
      throw Exception('Erro inesperado: ${e.toString()}');
    }
  }
}

