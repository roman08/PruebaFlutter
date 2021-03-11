import 'package:Neobank/app.dart';
import 'package:Neobank/common/bloc/loader_bloc.dart';
import 'package:Neobank/common/repository/user_repository.dart';
import 'package:Neobank/common/session/cubit/session_cubit.dart';
import 'package:Neobank/flows/sign_up_flow/screens/sign_up_screen/entities/sign_up_errors.dart';
import 'package:Neobank/flows/sign_up_flow/screens/sign_up_screen/models/sign_up_models.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:network_utils/resource.dart';

part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit(
    this._repository,
    this._loaderBloc,
    this._sessionBloc,
  ) : super(const SignUpState());

  final UserRepository _repository;
  final LoaderBloc _loaderBloc;
  final SessionCubit _sessionBloc;

  void emailChanged(String value) {
    final email = EmailInput.dirty(value);
    emit(state.copyWith(
      email: email,
      status: Formz.validate([
        email,
        state.password,
        state.confirmPassword,
        state.phone,
      ]),
    ));
  }

  void passwordChanged(String value) {
    final password = PasswordInput.dirty(value);
    emit(state.copyWith(
      password: password,
      status: Formz.validate([
        state.email,
        password,
        state.confirmPassword,
        state.phone,
      ]),
    ));
  }

  void confirmPasswordChanged(String value) {
    final confirmPassword = PasswordConfirmInput.dirty(value);
    emit(state.copyWith(
      confirmPassword: confirmPassword,
      status: Formz.validate([
        state.email,
        state.password,
        confirmPassword,
        state.phone,
      ]),
    ));
  }

  void dialCodeChanged(String value) {
    emit(state.copyWith(dialCode: value));
  }

  void phoneChanged(String value) {
    final phone = PhoneInput.dirty(value);
    emit(state.copyWith(
      phone: phone,
      status: Formz.validate([
        state.email,
        state.password,
        state.confirmPassword,
        phone,
      ]),
    ));
  }

  void signUpRequest() {
    if (!state.status.isValidated) {
      return;
    }

    final email = state.email.value.trim();
    final password = state.password.value;
    final confirmPassword = state.confirmPassword.value;
    final phoneNumber = state.phoneNumber;

    _repository
        .signUp(
      email: email,
      password: password,
      confirmPassword: confirmPassword,
      phoneNumber: phoneNumber,
    )
        .listen((resource) {
      logger.d(resource);
      switch (resource.status) {
        case Status.success:
          _loaderBloc.add(LoaderEvent.stopButtonLoadEvent);
          emit(state.copyWith(status: FormzStatus.submissionSuccess));
          return;
        case Status.loading:
          _loaderBloc.add(LoaderEvent.buttonLoadEvent);
          emit(state.copyWith(status: FormzStatus.submissionInProgress));
          break;
        case Status.error:
          _loaderBloc.add(LoaderEvent.stopButtonLoadEvent);
          emit(state.copyWith(
            status: FormzStatus.submissionFailure,
            backendErrors: SignUpErrors.fromList(resource.errors),
          ));
          return;
      }
    });
  }

  void signInUserAndGoToSetPasscode() {
    final email = state.email.value.trim();
    final password = state.password.value;

    this._repository.signIn(email: email, password: password).listen((resource) {
      logger.d(resource);
      switch (resource.status) {
        case Status.success:
          _loaderBloc.add(LoaderEvent.stopButtonLoadEvent);
          _sessionBloc.sessionCreatingPassCodeEvent(isSignIn: false);
          return;
        case Status.loading:
          _loaderBloc.add(LoaderEvent.buttonLoadEvent);
          emit(state.copyWith(status: FormzStatus.submissionInProgress));
          break;
        case Status.error:
          _loaderBloc.add(LoaderEvent.stopButtonLoadEvent);
          emit(state.copyWith(
            status: FormzStatus.submissionFailure,
            backendErrors: SignUpErrors.fromList(resource.errors),
          ));
          return;
      }
    });
  }
}
