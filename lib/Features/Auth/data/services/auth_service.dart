import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';

class AuthService {
  final SupabaseClient _client = Supabase.instance.client;

  // REGISTER
  Future<UserModel> signUp(String email, String password) async {
    try {
      print('🚀 Attempting to sign up with email: $email');

      final response = await _client.auth.signUp(
        email: email,
        password: password,
      );

      print('📥 Supabase signUp response: $response');

      if (response.user != null) {
        print('✅ SignUp successful: ${response.user!.id}');
        return UserModel(id: response.user!.id, email: response.user!.email!);
      } else {
        print('❌ SignUp failed, session: ${response.session}');
        throw Exception(
          response.session == null
              ? 'حدث خطأ أثناء التسجيل'
              : 'Unknown error occurred',
        );
      }
    } catch (e, st) {
      print('🔥 SignUp exception: $e');
      print(st);
      rethrow;
    }
  }

  // LOGIN
  Future<UserModel> signIn(String email, String password) async {
    try {
      print('🚀 Attempting to sign in with email: $email');

      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      print('📥 Supabase signIn response: $response');

      if (response.user != null) {
        print('✅ SignIn successful: ${response.user!.id}');
        return UserModel(id: response.user!.id, email: response.user!.email!);
      } else {
        print('❌ SignIn failed, session: ${response.session}');
        throw Exception(
          response.session == null
              ? 'حدث خطأ أثناء تسجيل الدخول'
              : 'Unknown error occurred',
        );
      }
    } catch (e, st) {
      print('🔥 SignIn exception: $e');
      print(st);
      rethrow;
    }
  }

  // LOGOUT
  Future<void> signOut() async {
    try {
      print('🚀 Attempting to sign out...');
      await _client.auth.signOut();
      print('✅ SignOut successful');
    } catch (e, st) {
      print('🔥 SignOut exception: $e');
      print(st);
      rethrow;
    }
  }

  // ✅ Get current user
  UserModel? getCurrentUser() {
    final user = _client.auth.currentUser;
    if (user != null) {
      return UserModel(id: user.id, email: user.email ?? '');
    }
    return null;
  }
}
