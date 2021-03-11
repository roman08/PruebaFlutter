part of 'sign_up_cubit.dart';

const DEFAULT_DIAL_CODE = '+44';

class SignUpState extends Equatable {
  const SignUpState({
    this.email = const EmailInput.pure(),
    this.password = const PasswordInput.pure(),
    this.confirmPassword = const PasswordConfirmInput.pure(),
    this.dialCode = DEFAULT_DIAL_CODE,
    this.phone = const PhoneInput.pure(),
    this.status = FormzStatus.pure,
    this.backendErrors = const SignUpErrors(),
  });

  final EmailInput email;
  final PasswordInput password;
  final PasswordConfirmInput confirmPassword;
  final String dialCode;
  final PhoneInput phone;
  final FormzStatus status;
  final SignUpErrors backendErrors;

  @override
  List<Object> get props => [
        email,
        password,
        confirmPassword,
        dialCode,
        phone,
        status,
        backendErrors,
      ];

  String get phoneNumber => '$dialCode${phone.value}'.trim();

  SignUpState copyWith({
    EmailInput email,
    PasswordInput password,
    PasswordConfirmInput confirmPassword,
    String dialCode,
    PhoneInput phone,
    FormzStatus status,
    SignUpErrors backendErrors,
  }) {
    return SignUpState(
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      dialCode: dialCode ?? this.dialCode,
      phone: phone ?? this.phone,
      status: status ?? this.status,
      backendErrors: backendErrors ?? this.backendErrors,
    );
  }

  @override
  String toString() {
    return 'SignUpState{email: $email, password: $password, confirmPassword: $confirmPassword, dialCode: $dialCode, phone: $phone, status: $status, backendErrors: $backendErrors}';
  }
}
