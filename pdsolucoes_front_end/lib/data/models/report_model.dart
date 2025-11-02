import 'package:pdsolucoes_front_end/domain/entities/report_entity.dart';
import 'package:pdsolucoes_front_end/domain/entities/member_hours_entity.dart';
import 'package:pdsolucoes_front_end/domain/entities/total_hours_entity.dart';
import 'package:pdsolucoes_front_end/domain/entities/average_hours_entity.dart';
import 'package:pdsolucoes_front_end/domain/entities/dashboard_entity.dart';
import 'package:pdsolucoes_front_end/domain/entities/squad_stats_entity.dart';

class ReportModel {
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

  ReportModel({
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

  ReportEntity toEntity() {
    return ReportEntity(
      id: id,
      description: description,
      date: date,
      hours: hours,
      employeeId: employeeId,
      employeeName: employeeName,
      squadId: squadId,
      squadName: squadName,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    final employee = json['employee'] as Map<String, dynamic>?;
    final squad = employee?['squad'] as Map<String, dynamic>?;
    
    return ReportModel(
      id: json['id'] ?? '',
      description: json['description'] ?? '',
      date: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : DateTime.now(),
      hours: json['spentHours'] ?? 0,
      employeeId: json['employeeId'] ?? '',
      employeeName: employee?['name'] ?? '',
      squadId: employee?['squadId'] ?? '',
      squadName: squad?['name'] ?? '',
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null 
          ? DateTime.parse(json['updatedAt']) 
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'date': date.toIso8601String(),
      'hours': hours,
      'employeeId': employeeId,
      'employeeName': employeeName,
      'squadId': squadId,
      'squadName': squadName,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class MemberHoursModel {
  final String employeeId;
  final String employeeName;
  final int totalHours;

  MemberHoursModel({
    required this.employeeId,
    required this.employeeName,
    required this.totalHours,
  });

  factory MemberHoursModel.fromJson(Map<String, dynamic> json) {
    return MemberHoursModel(
      employeeId: json['employeeId'] ?? '',
      employeeName: json['employeeName'] ?? '',
      totalHours: json['totalHours'] ?? 0,
    );
  }

  MemberHoursEntity toEntity() {
    return MemberHoursEntity(
      employeeId: employeeId,
      employeeName: employeeName,
      totalHours: totalHours,
    );
  }
}

class TotalHoursModel {
  final int totalHours;

  TotalHoursModel({required this.totalHours});

  factory TotalHoursModel.fromJson(Map<String, dynamic> json) {
    return TotalHoursModel(
      totalHours: json['totalHours'] ?? 0,
    );
  }

  TotalHoursEntity toEntity() {
    return TotalHoursEntity(
      totalHours: totalHours,
    );
  }
}

class AverageHoursModel {
  final double averageHours;

  AverageHoursModel({required this.averageHours});

  factory AverageHoursModel.fromJson(Map<String, dynamic> json) {
    return AverageHoursModel(
      averageHours: (json['averageHours'] ?? 0).toDouble(),
    );
  }

  AverageHoursEntity toEntity() {
    return AverageHoursEntity(
      averageHours: averageHours,
    );
  }
}

class DashboardModel {
  final int totalSquads;
  final int totalEmployees;
  final int totalReports;
  final double averageHoursPerDay;
  final List<SquadStatsModel> squadStats;

  DashboardModel({
    required this.totalSquads,
    required this.totalEmployees,
    required this.totalReports,
    required this.averageHoursPerDay,
    required this.squadStats,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      totalSquads: json['totalSquads'] ?? 0,
      totalEmployees: json['totalEmployees'] ?? 0,
      totalReports: json['totalReports'] ?? 0,
      averageHoursPerDay: (json['averageHoursPerDay'] ?? 0).toDouble(),
      squadStats: (json['squadStats'] as List<dynamic>?)
              ?.map((e) => SquadStatsModel.fromJson(e))
              .toList() ??
          [],
    );
  }

  DashboardEntity toEntity() {
    return DashboardEntity(
      totalSquads: totalSquads,
      totalEmployees: totalEmployees,
      totalReports: totalReports,
      averageHoursPerDay: averageHoursPerDay,
      squadStats: squadStats.map((model) => model.toEntity()).toList(),
    );
  }
}

class SquadStatsModel {
  final String squadId;
  final String squadName;
  final int totalHours;
  final int employeeCount;

  SquadStatsModel({
    required this.squadId,
    required this.squadName,
    required this.totalHours,
    required this.employeeCount,
  });

  factory SquadStatsModel.fromJson(Map<String, dynamic> json) {
    return SquadStatsModel(
      squadId: json['squadId'] ?? '',
      squadName: json['squadName'] ?? '',
      totalHours: json['totalHours'] ?? 0,
      employeeCount: json['employeeCount'] ?? 0,
    );
  }

  SquadStatsEntity toEntity() {
    return SquadStatsEntity(
      squadId: squadId,
      squadName: squadName,
      totalHours: totalHours,
      employeeCount: employeeCount,
    );
  }
}

