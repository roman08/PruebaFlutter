import 'package:Neobank/app.dart';
import 'package:Neobank/common/bloc/loader_bloc.dart';
import 'package:Neobank/common/repository/user_repository.dart';
import 'package:Neobank/flows/sign_in_flow/screens/sign_in_screen/entities/sign_in_errors.dart';
import 'package:Neobank/flows/sign_in_flow/screens/sign_in_screen/models/sign_in_models.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:network_utils/resource.dart';

part 'sign_in_state.dart';

class SignInCubit extends Cubit<SignInState> {
  SignInCubit(
    this._repository,
    this._loaderBloc,
  ) : super(const SignInState());

  final UserRepository _repository;
  final LoaderBloc _loaderBloc;

  void loginChanged(String value) {
    final login = LoginInput.dirty(value);
    emit(state.copyWith(
      login: login,
      status: Formz.validate([login, state.password]),
    ));
  }

  void passwordChanged(String value) {
    final password = PasswordInput.dirty(value);
    emit(state.copyWith(
      password: password,
      status: Formz.validate([password, state.login]),
    ));
  }

  void signInRequest() {
    print('signInRequest');
    if (!state.status.isValidated) {
      return;
    }

    print('isValidated');
    final login = state.login.value;
    final password = state.password.value;
    print(login);
    print(password);

    _repository.signIn(email: login, password: password).listen((resource) {
      logger.d(resource);

      switch (resource.status) {
        case Status.success:
          _getUserData();
          return;
        case Status.loading:
          _loaderBloc.add(LoaderEvent.buttonLoadEvent);
          emit(state.copyWith(status: FormzStatus.submissionInProgress));
          break;
        case Status.error:
          _loaderBloc.add(LoaderEvent.stopButtonLoadEvent);
          emit(state.copyWith(
              status: FormzStatus.submissionFailure, backendErrors: SignInErrors.fromList(resource.errors)));
          return;
      }
    });
  }

  void _getUserData() {
    _repository.getUserData().listen((resource) {
      logger.d(resource);

      switch (resource.status) {
        case Status.success:
          _loaderBloc.add(LoaderEvent.stopButtonLoadEvent);
          emit(state.copyWith(status: FormzStatus.submissionSuccess));
          return;
        case Status.loading:
          break;
        case Status.error:
          _loaderBloc.add(LoaderEvent.stopButtonLoadEvent);
          emit(state.copyWith(
              status: FormzStatus.submissionFailure, backendErrors: SignInErrors.fromList(resource.errors)));
          return;
      }
    });
  }
}
