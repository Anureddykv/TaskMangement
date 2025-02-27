import 'package:flutter_bloc/flutter_bloc.dart';
import '../repositry/user_repository.dart';

// Events
abstract class UserEvent {}

class LoadUsers extends UserEvent {}

class LoadUserById extends UserEvent {
  final int userId;
  LoadUserById(this.userId);
}

// States
abstract class UserState {}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final List<dynamic> users;
  UserLoaded(this.users);
}

class SingleUserLoaded extends UserState {
  final Map<String, dynamic> user;
  SingleUserLoaded(this.user);
}

class UserError extends UserState {
  final String message;
  UserError(this.message);
}

// Bloc
class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;

  UserBloc(this.userRepository) : super(UserInitial()) {
    on<LoadUsers>((event, emit) async {
      emit(UserLoading());
      try {
        final users = await userRepository.fetchUsers();
        emit(UserLoaded(users));
      } catch (e) {
        emit(UserError("Failed to load users"));
      }
    });

    on<LoadUserById>((event, emit) async {
      emit(UserLoading());
      try {
        final user = await userRepository.fetchUserById(event.userId);
        emit(SingleUserLoaded(user));
      } catch (e) {
        emit(UserError("Failed to load user"));
      }
    });
  }
}
