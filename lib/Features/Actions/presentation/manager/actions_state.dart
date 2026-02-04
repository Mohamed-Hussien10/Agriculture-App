import 'package:agriculture_app/Features/Actions/data/models/action_model.dart';

abstract class ActionsState {}

class ActionsInitial extends ActionsState {}

class ActionsLoaded extends ActionsState {
  final List<ActionItemModel> actions;

  ActionsLoaded({required this.actions});
}

class ActionsError extends ActionsState {
  final String message;

  ActionsError({required this.message});
}
