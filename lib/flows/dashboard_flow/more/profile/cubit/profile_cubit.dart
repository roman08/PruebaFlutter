import 'dart:typed_data';

import 'package:Neobank/common/repository/user_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:network_utils/resource.dart';

import '../../../../../app.dart';
import '../../../../../common/session/session_repository.dart';
import '../../../../../resources/strings/app_strings.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(this._sessionRepository, this._userRepository)
      : super(
          ProfileState(
            firstName: _sessionRepository.userData.value?.firstName ?? '',
            lastName: _sessionRepository.userData.value?.lastName ?? '',
            nickName: _sessionRepository.userData.value?.nickname ?? '',
          ),
        ) {
    _sessionRepository.userData.listen((event) {
      update(
        firstName: event.firstName ?? '',
        lastName: event.lastName ?? '',
        nickName: event.nickname ?? '',
        avatarId: event.profileImageId,
      );
    });
  }

  final SessionRepository _sessionRepository;
  final UserRepository _userRepository;

  void update({
    String firstName,
    String lastName,
    String nickName,
    int avatarId,
  }) async {
    final Uint8List avatar = await _userRepository.downloadAvatar(avatarId);
    emit(ProfileUpdatedState(
      firstName: firstName,
      lastName: lastName,
      nickName: nickName,
      avatar: avatar,
    ));
  }

  void updateNickName({String nickName}) {
    if (nickName.length < 3) {
      emit(ProfileUpdatingErrorState(
        firstName: _sessionRepository.userData.value.firstName,
        lastName: _sessionRepository.userData.value.lastName,
        nickName: nickName,
        avatar: state.avatar,
        error: ErrorStrings.SHOULD_BE_MINIMUM_THREE_CHARACTERS,
      ));
      return;
    }
    updateProfile(nickName: nickName);
  }

  void updateProfile({String firstName, String lastName, String nickName}) async {
    await for (final event
        in _userRepository.updateUserData(firstName: firstName, lastName: lastName, nickName: nickName)) {
      if (event.status == Status.success) {
        logger.d("profile was updated");
        emit(ProfileUpdatedState(
          firstName: firstName ?? _sessionRepository.userData.value.firstName,
          lastName: lastName ?? _sessionRepository.userData.value.lastName,
          nickName: nickName ?? _sessionRepository.userData.value.nickname,
          avatar: state.avatar,
        ));
        return;
      } else if (event.status == Status.loading) {
        emit(ProfileLoadingState());
      } else {
        return;
      }
    }
  }

  void updateName({String firstName, String lastName}) {
    if (firstName.isEmpty) {
      emit(ProfileUpdatingErrorState(
        firstName: firstName,
        lastName: lastName,
        nickName: _sessionRepository.userData.value.nickname,
        avatar: state.avatar,
        error: ErrorStrings.FIRST_NAME_SHOULD_NOT_BE_EMPTY,
      ));
      return;
    }
    if (lastName.isEmpty) {
      emit(ProfileUpdatingErrorState(
          firstName: firstName,
          lastName: lastName,
          nickName: _sessionRepository.userData.value.nickname,
          avatar: state.avatar,
          error: ErrorStrings.SECOND_NAME_SHOULD_NOT_BE_EMPTY));
      return;
    }
    updateProfile(firstName: firstName, lastName: lastName);
  }

  void updateAvatar({String filePath}) async {
    await for (final event in _userRepository.uploadAvatar(filePath)) {
      if (event.status == Status.success) {
        logger.d("avatar was uploaded");
        return;
      } else if (event.status == Status.loading) {
        emit(ProfileLoadingState());
      } else {
        updateProfile(
          firstName: _sessionRepository.userData.value.firstName,
          lastName: _sessionRepository.userData.value.lastName,
          nickName: _sessionRepository.userData.value.nickname,
        );
        return;
      }
    }
  }
}
