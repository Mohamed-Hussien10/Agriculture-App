import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/services/auth_service.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthService authService;
  AuthCubit(this.authService) : super(AuthInitial());

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    try {
      final user = await authService.signIn(email, password);
      emit(AuthSuccess(user));
    } catch (e) {
      emit(AuthFailure(_mapErrorToMessage(e)));
    }
  }

  Future<void> register(String email, String password) async {
    emit(AuthLoading());
    try {
      final user = await authService.signUp(email, password);
      emit(AuthSuccess(user));
    } catch (e) {
      emit(AuthFailure(_mapErrorToMessage(e)));
    }
  }

  Future<void> logout() async {
    await authService.signOut();
    emit(AuthInitial());
  }

  // تحويل الأخطاء لرسائل مفهومة للمستخدم
  String _mapErrorToMessage(dynamic e) {
    final message = e.toString().toLowerCase();

    if (message.contains('invalid_credentials')) {
      return 'البريد الإلكتروني أو كلمة المرور غير صحيحة';
    } else if (message.contains('email already exists') ||
        message.contains('duplicate key value') ||
        message.contains('user already registered')) {
      return 'هذا البريد الإلكتروني مسجل بالفعل';
    } else if (message.contains('password should be at least')) {
      return 'كلمة المرور قصيرة جدًا، يجب أن تكون أطول';
    } else if (message.contains('network')) {
      return 'فشل الاتصال بالإنترنت، يرجى المحاولة لاحقًا';
    } else {
      return 'حدث خطأ غير متوقع، يرجى المحاولة مرة أخرى';
    }
  }
}
