part of 'dashboard_cubit.dart';

abstract class DashboardState {}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardConnected extends DashboardState {
  final Map<String, String> liveData;

  DashboardConnected({required this.liveData});
}

class DashboardDisconnected extends DashboardState {}

class DashboardLiveUpdated extends DashboardState {
  final Map<String, String> liveData;

  DashboardLiveUpdated({required this.liveData});
}

class DashboardError extends DashboardState {
  final String message;

  DashboardError({required this.message});
}

class DashboardAlertsUpdated extends DashboardState {
  final List<Alert> alerts;

  DashboardAlertsUpdated({required this.alerts});
}
