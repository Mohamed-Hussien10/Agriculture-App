import 'dart:io';
import 'package:agriculture_app/Features/Dashboard/data/services/model_service.dart';
import 'package:agriculture_app/Features/Dashboard/presentation/manager/model_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ModelCubit extends Cubit<ModelState> {
  final ModelService service;

  ModelCubit(this.service) : super(ModelInitial());

  Future<void> detect(File image) async {
    emit(ModelLoading());
    try {
      final result = await service.detectObjects(image);
      emit(ModelLoaded(result));
    } catch (e) {
      emit(ModelError(e.toString()));
    }
  }

  void reset() {
    emit(ModelInitial()); 
  }
}
