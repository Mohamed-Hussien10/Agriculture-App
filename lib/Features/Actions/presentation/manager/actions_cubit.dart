import 'package:agriculture_app/Features/Actions/data/models/action_model.dart';
import 'package:agriculture_app/Features/Actions/data/services/actions_local_service.dart';
import 'package:agriculture_app/Features/Actions/presentation/manager/actions_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ActionsCubit extends Cubit<ActionsState> {
  List<ActionItemModel> actions = [];

  ActionsCubit() : super(ActionsInitial()) {
    loadActions();
  }

  // =========================
  // Load saved actions
  // =========================
  Future<void> loadActions() async {
    actions = await ActionsLocalService.getActions();
    emit(ActionsLoaded(actions: actions));
  }

  // =========================
  // Add new action (prevent duplicates)
  // =========================
  Future<void> addAction(ActionItemModel action) async {
    bool exists = actions.any(
      (a) => a.title == action.title && a.description == action.description,
    );
    if (exists) return;

    actions.insert(0, action);
    await ActionsLocalService.saveActions(actions);
    emit(ActionsLoaded(actions: actions));
  }

  // =========================
  // Delete a specific action
  // =========================
  Future<void> deleteAction(ActionItemModel action) async {
    actions.removeWhere(
      (a) => a.title == action.title && a.description == action.description,
    );
    await ActionsLocalService.saveActions(actions);
    emit(ActionsLoaded(actions: actions));
  }

  // =========================
  // Clear all actions
  // =========================
  Future<void> clearActions() async {
    actions.clear();
    await ActionsLocalService.saveActions(actions);
    emit(ActionsLoaded(actions: actions));
  }
}
