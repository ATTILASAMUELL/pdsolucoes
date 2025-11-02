abstract class SquadEvent {}

class LoadSquadsEvent extends SquadEvent {
  final String? search;
  final bool isInitialLoad;

  LoadSquadsEvent({this.search, this.isInitialLoad = false});
}

class CreateSquadEvent extends SquadEvent {
  final String name;

  CreateSquadEvent({required this.name});
}


