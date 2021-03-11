import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class ProfileState extends Equatable {
  const ProfileState({
    @required this.firstName,
    @required this.lastName,
    @required this.nickName,
     this.avatar,
  });

  final String firstName;
  final String lastName;
  final String nickName;
  final Uint8List avatar;

  ProfileState copyWith({
    String firstName,
    String lastName,
    String nickName,
    Uint8List avatar,
  }) {
    return ProfileState(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      nickName: nickName ?? this.nickName,
      avatar: avatar ?? this.avatar,
    );
  }

  @override
  List<Object> get props => [firstName, lastName, nickName];

  @override
  String toString() => "${super.toString()} firstName = $firstName, lastName = $lastName,  nickName = $nickName";
}

class ProfileUpdatedState extends ProfileState {
  const ProfileUpdatedState({
    @required String firstName,
    @required String lastName,
    @required String nickName,
    @required Uint8List avatar,
  }) : super(
          firstName: firstName,
          lastName: lastName,
          nickName: nickName,
          avatar: avatar,
        );
}

class ProfileLoadingState extends ProfileState {}

class ProfileUpdatingErrorState extends ProfileState {
  final String error;

  const ProfileUpdatingErrorState({
    @required String firstName,
    @required String lastName,
    @required String nickName,
    @required Uint8List avatar,
    @required this.error,
  }) : super(
    firstName: firstName,
    lastName: lastName,
    nickName: nickName,
    avatar: avatar,
  );
}