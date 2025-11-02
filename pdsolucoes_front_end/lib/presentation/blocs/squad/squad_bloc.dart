import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdsolucoes_front_end/domain/usecases/get_all_squads_usecase.dart';
import 'package:pdsolucoes_front_end/domain/usecases/create_squad_usecase.dart';
import 'package:pdsolucoes_front_end/presentation/blocs/squad/squad_event.dart';
import 'package:pdsolucoes_front_end/presentation/blocs/squad/squad_state.dart';

class SquadBloc extends Bloc<SquadEvent, SquadState> {
  final GetAllSquadsUseCase getAllSquadsUseCase;
  final CreateSquadUseCase createSquadUseCase;

  SquadBloc({
    required this.getAllSquadsUseCase,
    required this.createSquadUseCase,
  }) : super(SquadInitial()) {
    on<LoadSquadsEvent>(_onLoadSquads);
    on<CreateSquadEvent>(_onCreateSquad);
  }

  Future<void> _onLoadSquads(
      LoadSquadsEvent event, Emitter<SquadState> emit) async {
    if (event.isInitialLoad) {
      emit(SquadLoading());
    } else if (state is SquadLoaded) {
      emit(SquadSearching(currentSquads: (state as SquadLoaded).squads));
    }

    try {
      final squads = await getAllSquadsUseCase.call(search: event.search);
      emit(SquadLoaded(squads: squads));
    } catch (e) {
      emit(SquadError(message: e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _onCreateSquad(
      CreateSquadEvent event, Emitter<SquadState> emit) async {
    emit(SquadCreating());

    try {
      final squad = await createSquadUseCase.call(name: event.name);
      
      emit(SquadCreated(squad: squad));
      
      add(LoadSquadsEvent(isInitialLoad: true));
    } catch (e) {
      emit(SquadError(message: e.toString().replaceAll('Exception: ', '')));
    }
  }
}


