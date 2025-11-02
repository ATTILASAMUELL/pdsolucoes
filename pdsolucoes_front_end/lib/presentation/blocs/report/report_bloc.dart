import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdsolucoes_front_end/domain/usecases/create_report_usecase.dart';
import 'package:pdsolucoes_front_end/domain/usecases/get_dashboard_usecase.dart';
import 'package:pdsolucoes_front_end/domain/usecases/get_all_reports_usecase.dart';
import 'package:pdsolucoes_front_end/domain/repositories/report_repository.dart';
import 'package:pdsolucoes_front_end/presentation/blocs/report/report_event.dart';
import 'package:pdsolucoes_front_end/presentation/blocs/report/report_state.dart';

class ReportBloc extends Bloc<ReportEvent, ReportState> {
  final CreateReportUseCase createReportUseCase;
  final GetDashboardUseCase getDashboardUseCase;
  final GetAllReportsUseCase getAllReportsUseCase;
  final ReportRepository repository;

  ReportBloc({
    required this.createReportUseCase,
    required this.getDashboardUseCase,
    required this.getAllReportsUseCase,
    required this.repository,
  }) : super(ReportInitial()) {
    on<LoadAllReportsEvent>(_onLoadAllReports);
    on<CreateReportEvent>(_onCreateReport);
    on<LoadDashboardEvent>(_onLoadDashboard);
    on<LoadSquadMemberHoursEvent>(_onLoadSquadMemberHours);
    on<LoadSquadTotalHoursEvent>(_onLoadSquadTotalHours);
    on<LoadSquadAverageHoursEvent>(_onLoadSquadAverageHours);
  }

  Future<void> _onLoadAllReports(
    LoadAllReportsEvent event,
    Emitter<ReportState> emit,
  ) async {
    emit(ReportLoading());

    try {
      final reports = await getAllReportsUseCase.call();
      emit(ReportsLoaded(reports: reports));
    } catch (e) {
      emit(ReportError(message: e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _onCreateReport(
    CreateReportEvent event,
    Emitter<ReportState> emit,
  ) async {
    emit(ReportCreating());

    try {
      final report = await createReportUseCase.call(
        description: event.description,
        date: event.date,
        hours: event.hours,
        employeeId: event.employeeId,
      );

      emit(ReportCreated(report: report));
      
      add(LoadAllReportsEvent());
    } catch (e) {
      emit(ReportError(message: e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _onLoadDashboard(
    LoadDashboardEvent event,
    Emitter<ReportState> emit,
  ) async {
    emit(ReportLoading());

    try {
      final dashboard = await getDashboardUseCase.call(
        startDate: event.startDate,
        endDate: event.endDate,
      );

      emit(DashboardLoaded(dashboard: dashboard));
    } catch (e) {
      emit(ReportError(message: e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _onLoadSquadMemberHours(
    LoadSquadMemberHoursEvent event,
    Emitter<ReportState> emit,
  ) async {
    emit(ReportLoading());

    try {
      final memberHours = await repository.getSquadMemberHours(
        squadId: event.squadId,
        startDate: event.startDate,
        endDate: event.endDate,
      );

      emit(MemberHoursLoaded(memberHours: memberHours));
    } catch (e) {
      emit(ReportError(message: e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _onLoadSquadTotalHours(
    LoadSquadTotalHoursEvent event,
    Emitter<ReportState> emit,
  ) async {
    emit(ReportLoading());

    try {
      final totalHours = await repository.getSquadTotalHours(
        squadId: event.squadId,
        startDate: event.startDate,
        endDate: event.endDate,
      );

      emit(TotalHoursLoaded(totalHours: totalHours));
    } catch (e) {
      emit(ReportError(message: e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _onLoadSquadAverageHours(
    LoadSquadAverageHoursEvent event,
    Emitter<ReportState> emit,
  ) async {
    emit(ReportLoading());

    try {
      final averageHours = await repository.getSquadAverageHours(
        squadId: event.squadId,
        startDate: event.startDate,
        endDate: event.endDate,
      );

      emit(AverageHoursLoaded(averageHours: averageHours));
    } catch (e) {
      emit(ReportError(message: e.toString().replaceAll('Exception: ', '')));
    }
  }
}

