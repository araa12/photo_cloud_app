// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

import 'package:photo_cloud/auth/auth_error.dart';

extension GetUser on AppState {
  User? get user {
    final className = this;
    if (className is AppStateLoggedIn) {
      return className.user;
    } else {
      return null;
    }
  }
}

extension GetImages on AppState {
  Iterable<Reference>? get images {
    final className = this;
    if (className is AppStateLoggedIn) {
      return className.images;
    } else {
      return null;
    }
  }
}

@immutable
abstract class AppState {
  final bool isLoading;
  final AuthError? authError;
  const AppState({
    required this.isLoading,
    this.authError,
  });
}

@immutable
class AppStateLoggedIn extends AppState {
  final User user;
  final Iterable<Reference> images;
  const AppStateLoggedIn({
    required this.user,
    required this.images,
    required bool isLoading,
    AuthError? authError,
  }) : super(
          authError: authError,
          isLoading: isLoading,
        );

  @override
  bool operator ==(other) {
    final otherClass = other;
    if (otherClass is AppStateLoggedIn) {
      return isLoading == otherClass.isLoading &&
          user.uid == otherClass.user.uid &&
          images.length == otherClass.images.length;
    } else {
      return false;
    }
  }

  @override
  int get hashCode => Object.hash(user.uid, images);

  @override
  String toString() {
    return {
      'AppState Logged IN': 'State of App State',
      'User ID': user.uid,
      'isLoading': isLoading,
      'images Length': images.length,
      'Auth Erros': authError,
    }.toString();
  }
}

@immutable
class AppStateLoggedOut extends AppState {
  const AppStateLoggedOut({required bool isLoading, AuthError? authError})
      : super(authError: authError, isLoading: isLoading);

  @override
  String toString() {
    return ' AppState Logged Out isLoading = $isLoading and Auth Error $authError';
  }
}

@immutable
class AppStateIsInRegisterationView extends AppState {
  const AppStateIsInRegisterationView(
      {required bool isLoading, AuthError? authError})
      : super(authError: authError, isLoading: isLoading);
}
