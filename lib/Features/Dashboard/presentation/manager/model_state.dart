abstract class ModelState {}

class ModelInitial extends ModelState {}

class ModelLoading extends ModelState {}

class ModelLoaded extends ModelState {
  final Map<String, dynamic> data;
  ModelLoaded(this.data);
}

class ModelError extends ModelState {
  final String message;
  ModelError(this.message);
}
