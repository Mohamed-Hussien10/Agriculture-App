import 'package:agriculture_app/core/networking/dio_factory.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';

final getIt = GetIt.instance;

Future<void> setupGetIt() async {
  // ignore: unused_local_variable
  Dio dio = DioFactory.getDio();
}
