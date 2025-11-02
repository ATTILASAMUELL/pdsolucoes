import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdsolucoes_front_end/domain/usecases/get_all_employees_usecase.dart';
import 'package:pdsolucoes_front_end/domain/usecases/create_employee_usecase.dart';
import 'package:pdsolucoes_front_end/presentation/blocs/employee/employee_event.dart';
import 'package:pdsolucoes_front_end/presentation/blocs/employee/employee_state.dart';

class EmployeeBloc extends Bloc<EmployeeEvent, EmployeeState> {
  final GetAllEmployeesUseCase getAllEmployeesUseCase;
  final CreateEmployeeUseCase createEmployeeUseCase;

  EmployeeBloc({
    required this.getAllEmployeesUseCase,
    required this.createEmployeeUseCase,
  }) : super(EmployeeInitial()) {
    on<LoadEmployeesEvent>(_onLoadEmployees);
    on<CreateEmployeeEvent>(_onCreateEmployee);
  }

  Future<void> _onLoadEmployees(
      LoadEmployeesEvent event, Emitter<EmployeeState> emit) async {
    if (event.isInitialLoad) {
      emit(EmployeeLoading());
    } else if (state is EmployeeLoaded) {
      emit(EmployeeSearching(currentEmployees: (state as EmployeeLoaded).employees));
    }

    try {
      final employees = await getAllEmployeesUseCase.call(search: event.search);
      emit(EmployeeLoaded(employees: employees));
    } catch (e) {
      emit(EmployeeError(message: e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _onCreateEmployee(
      CreateEmployeeEvent event, Emitter<EmployeeState> emit) async {
    emit(EmployeeCreating());

    try {
      final employee = await createEmployeeUseCase.call(
        name: event.name,
        estimatedHours: event.estimatedHours,
        squadId: event.squadId,
      );

      emit(EmployeeCreated(employee: employee));
      
      add(LoadEmployeesEvent(isInitialLoad: true));
    } catch (e) {
      emit(EmployeeError(message: e.toString().replaceAll('Exception: ', '')));
    }
  }
}


