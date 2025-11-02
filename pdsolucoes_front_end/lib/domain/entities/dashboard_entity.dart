import 'package:pdsolucoes_front_end/domain/entities/squad_stats_entity.dart';

class DashboardEntity {
  final int totalSquads;
  final int totalEmployees;
  final int totalReports;
  final double averageHoursPerDay;
  final List<SquadStatsEntity> squadStats;

  DashboardEntity({
    required this.totalSquads,
    required this.totalEmployees,
    required this.totalReports,
    required this.averageHoursPerDay,
    required this.squadStats,
  });
}

