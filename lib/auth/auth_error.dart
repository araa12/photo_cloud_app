//* Maping Auth Errors From Firebase to Local Auth Error Classess *//
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuthException;
import 'package:flutter/foundation.dart' show immutable;

const Map<String, AuthError> authErrorMapping = {
  'user-not-found': AuthErrorUserNotFound(),
  'email-already-in-use': AuthErrorEmailAlreadyInUse(),
  'weak-password': AuthErrorWeakPassword(),
  'invalid-email': AuthErrorInvalidEmail(),
  'operation-not-allowed': AuthErrorOperationNotAllowed(),
  'requires-recent-login': AuthErrorRequiresRecentLogin(),
  'no-current-user': AuthErrorNoCurrentUser(),
  'wrong-password': AuthErrorWrongPassword()
};

@immutable
abstract class AuthError {
  final String title;
  final String errorDescription;

  const AuthError({
    required this.title,
    required this.errorDescription,
  });

  // * Create Auth Error From Firebase Auth Excption using [authError] property by matching key *//
  factory AuthError.from(FirebaseAuthException exception) =>
      authErrorMapping[exception.code.toLowerCase().trim()] ??
      AuthErrorUnknown(exception);
}

@immutable
class AuthErrorUnknown extends AuthError {
  final FirebaseAuthException innerException;
  const AuthErrorUnknown(this.innerException)
      : super(
          title: '😯 Unkown Auth Error',
          errorDescription: 'Unkown Authentication Error',
        );
}

@immutable
class AuthErrorWrongPassword extends AuthError {
  const AuthErrorWrongPassword()
      : super(
          title: 'Wrong Password',
          errorDescription:
              'You have entered wrong password \n Plz Enter Correct Password 😋',
        );
}

//* When No User Found in Firebase Auth *//
@immutable
class AuthErrorNoCurrentUser extends AuthError {
  const AuthErrorNoCurrentUser()
      : super(
          title: 'No current user!',
          errorDescription: 'No User Found with this Exception',
        );
}

///[requires-recent-login']///
@immutable
class AuthErrorRequiresRecentLogin extends AuthError {
  const AuthErrorRequiresRecentLogin()
      : super(
          title: 'Requires recent Login',
          errorDescription: 'No User Found with this Exception',
        );
}

/*

The provided sign-in provider is disabled for your Firebase project.
Enable it from the Sign-in Method section of the [Firebase console].

*/
@immutable
class AuthErrorOperationNotAllowed extends AuthError {
  const AuthErrorOperationNotAllowed()
      : super(
          title: 'Operation Not Allowed',
          errorDescription: 'Operation Not Allowed Add Signing Support',
        );
}

///[auth/user-not-found] Error ///
@immutable
class AuthErrorUserNotFound extends AuthError {
  const AuthErrorUserNotFound()
      : super(
          title: 'User not found',
          errorDescription: 'User was not found in server',
        );
}

///[weak-password]///
@immutable
class AuthErrorWeakPassword extends AuthError {
  const AuthErrorWeakPassword()
      : super(
          title: 'Weak Password',
          errorDescription:
              'Please Choose strong password with more than 6 characters',
        );
}

@immutable
class AuthErrorInvalidEmail extends AuthError {
  const AuthErrorInvalidEmail()
      : super(
          title: 'Invalid Email',
          errorDescription: 'Please check your email and try again!',
        );
}

///[auth/email-already-in-use]//
@immutable
class AuthErrorEmailAlreadyInUse extends AuthError {
  const AuthErrorEmailAlreadyInUse()
      : super(
          title: 'Email Already in Use',
          errorDescription:
              'Try to register with other email this email is already registered with this app',
        );
}
