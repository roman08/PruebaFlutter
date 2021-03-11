import 'package:Neobank/resources/strings/app_strings.dart';

const Map<String, String> CommonErrors = {
  'UNAUTHORIZED': 'invalid_password_or_email',
  'USERS_INVALID_USERNAME_OR_PASSWORD': 'invalid_password_or_email',
  'NO_TIME_TO_UNFREEZE': 'no_time_to_unfreeze',
  'PHONE_NUMBER_IS_NOT_CONFIRMED': ErrorStrings.PHONE_NUMBER_IS_NOT_CONFIRMED,
  'CANNOT_FORGOT_PASSWORD': ErrorStrings.CANNOT_FORGOT_PASSWORD,
  'INVALID_CONFIRMATION_CODE': ErrorStrings.INVALID_CONFIRMATION_CODE,
  'ACCOUNT_NOT_FOUND': ErrorStrings.ACCOUNT_NOT_FOUND,
  'NOT_FOUND': ErrorStrings.USER_NOT_FOUND,
  'USERS_USER_IS_DORMANT': ErrorStrings.USERS_USER_IS_DORMANT,
  'UNKNOWN_EMAIL_OR_PHONE_NUMBER': ErrorStrings.UNKNOWN_EMAIL_OR_PHONE_NUMBER,
};
