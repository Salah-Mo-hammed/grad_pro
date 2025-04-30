import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grad_project_ver_1/core/errors/failure.dart';
import 'package:grad_project_ver_1/features/auth/domain/usecases/forget_pass_usecase.dart';
import 'package:grad_project_ver_1/features/auth/domain/usecases/get_auth_usecase.dart.dart';
import 'package:grad_project_ver_1/features/auth/domain/usecases/login_usecase.dart';
import 'package:grad_project_ver_1/features/auth/domain/usecases/logout_usecase.dart';
import 'package:grad_project_ver_1/features/auth/domain/usecases/register_usecase.dart';
import 'package:grad_project_ver_1/features/auth/presintation/bloc/auth_event.dart';
import 'package:grad_project_ver_1/features/auth/presintation/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LogInUsecase logInUsecase;
  final LogOutUsecase logOutUsecase;
  final RegisterUsecase registerUsecase;
  final ForgetPassUsecase resetPassUseCase;
  final GetAuthStatusUseCase getAuthStatusUseCase;


  AuthBloc({
    required this.resetPassUseCase,
    required this.logInUsecase,
    required this.logOutUsecase,
    required this.registerUsecase,
    required this.getAuthStatusUseCase,
  }) : super(const AuthStateInitial()) {
    on<AuthLogInEvent>(_onLogIn);
    on<AuthLogOutEvent>(_onLogOut);
    on<AuthRegisterEvent>(_onRegister);
    on<AuthResetPassEvent>(_onResetPassword);
    on<GetAuthStatusEvent>(_onGetAuthStatus);
  }

  FutureOr<void> _onLogIn(AuthLogInEvent event, Emitter<AuthState> emit) async {
    emit(const AuthStateLoading());
    final result = await logInUsecase.call(event.email, event.password);

    result.fold(
      (failure) {
        emit(
          AuthStateException(exceptionMessage: _mapFailureToMessage(failure)),
        );
      },
      (user) async {
        emit(Authenticated(authUser: user));
      },
    );
  }

  FutureOr<void> _onLogOut(
    AuthLogOutEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthStateLoading());
    final result = await logOutUsecase.call();
    result.fold(
      (failure) {
        emit(
          AuthStateException(exceptionMessage: _mapFailureToMessage(failure)),
        );
      },
      (_) {
        emit(const AuthStateInitial());
      },
    );
  }
  //! done log in and out

  FutureOr<void> _onRegister(
    AuthRegisterEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthStateLoading());

    final result = await registerUsecase.call( event.email,event.password,event.role);

    result.fold(
      (failure) {
        emit(
          AuthStateException(exceptionMessage: _mapFailureToMessage(failure)),
        );
      },
      (user) {
        emit(Authenticated(authUser: user));
      },
    );
  }

  FutureOr<void> _onResetPassword(
    AuthResetPassEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthStateLoading());
    final result = await resetPassUseCase.call(event.email);
    result.fold(
      (failure) {
        emit(
          AuthStateException(exceptionMessage: _mapFailureToMessage(failure)),
        );
      },
      (_) {
        emit(AuthStateInitial());
      },
    );
  }

  FutureOr<void> _onGetAuthStatus(
    GetAuthStatusEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthStateLoading());
    final isLoggedIn = await getAuthStatusUseCase.call();
    emit(AuthStatusChecked(isLoggedIn: isLoggedIn));
  }

  //! helper for failuers
  String _mapFailureToMessage(Failure failure) {
    if (failure is AuthFailure) {
      return failure.message;
    }
    return "An unexpected error occurred. Please try again.";
  }
}