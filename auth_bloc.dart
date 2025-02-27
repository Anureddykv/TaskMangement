import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_mangement_project/auth/auth_event.dart';
import 'package:task_mangement_project/auth/auth_state.dart';
import 'package:task_mangement_project/repositry/auth_repository.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
  }

  void _onLoginRequested(LoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    try {
      final token = await authRepository.login(event.email, event.password);
      emit(AuthAuthenticated( token: token ?? ''));
    } catch (e) {
      emit(AuthError(message: "Login failed. Check credentials."));
    }
  }
}
