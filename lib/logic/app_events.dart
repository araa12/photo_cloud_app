// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract class AppEvent {
  const AppEvent();
}

@immutable
class AppEventInitializeApp implements AppEvent {
  const AppEventInitializeApp();
}

@immutable
class AppEventLoginUser implements AppEvent {
  final String email;
  final String password;
  const AppEventLoginUser({
    required this.email,
    required this.password,
  });
}

@immutable
class AppEventRegisterUser implements AppEvent {
  final String email;
  final String password;
  const AppEventRegisterUser({
    required this.email,
    required this.password,
  });
}

@immutable
class AppEventUploadImage implements AppEvent {
  final String pathOfFileToUpload;
  const AppEventUploadImage({required this.pathOfFileToUpload});
}

@immutable
class AppEventDeleteAccount implements AppEvent {
  const AppEventDeleteAccount();
}

@immutable
class AppEventLogoutUser implements AppEvent {
  const AppEventLogoutUser();
}

@immutable
class AppEventGoToRegistration implements AppEvent {
  const AppEventGoToRegistration();
}

@immutable
class AppEventGoToLogin implements AppEvent {
  const AppEventGoToLogin();
}
