import 'package:pdsolucoes_front_end/domain/entities/squad_entity.dart';

abstract class SquadState {}

class SquadInitial extends SquadState {}

class SquadLoading extends SquadState {}

class SquadSearching extends SquadState {
  final List<SquadEntity> currentSquads;

  SquadSearching({required this.currentSquads});
}

class SquadLoaded extends SquadState {
  final List<SquadEntity> squads;

  SquadLoaded({required this.squads});
}

class SquadCreating extends SquadState {}

class SquadCreated extends SquadState {
  final SquadEntity squad;

  SquadCreated({required this.squad});
}

class SquadError extends SquadState {
  final String message;

  SquadError({required this.message});
}
