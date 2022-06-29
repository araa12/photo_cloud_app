import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:photo_cloud/auth/auth_error.dart';
import 'package:photo_cloud/logic/app_events.dart';
import 'package:photo_cloud/logic/app_state.dart';
import 'package:photo_cloud/utils/upload_image.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc() : super(const AppStateLoggedOut(isLoading: false)) {
    //* Initialize The App and Check for User *///
    on<AppEventInitializeApp>((event, emit) async {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        emit(const AppStateLoggedOut(isLoading: false));
      } else {
        final images = await _getImages(user.uid);

        emit(
          AppStateLoggedIn(
            user: user,
            images: images,
            isLoading: false,
          ),
        );
      }
    });

    //* Register THe user with [Email and Passsowrd] *//
    on<AppEventRegisterUser>((event, emit) async {
      emit(
        const AppStateIsInRegisterationView(
          isLoading: true,
        ),
      );

      final email = event.email;
      final password = event.password;

      try {
        ///Create [User]///
        final creds = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);

        final userID = creds.user!.uid;

        emit(
          AppStateLoggedIn(
            user: creds.user!,
            images: const [],
            isLoading: false,
          ),
        );
      } on FirebaseAuthException catch (e) {
        emit(
          AppStateIsInRegisterationView(
            isLoading: false,
            authError: AuthError.from(e),
          ),
        );
      }
    });

    ///Go to [Login Screen Event] when user is not logged in//
    ///
    on<AppEventGoToLogin>((event, emit) {
      emit(
        const AppStateLoggedOut(
          isLoading: false,
        ),
      );
    });

    //*Login The USer *//

    on<AppEventLoginUser>((event, emit) async {
      emit(
        const AppStateLoggedOut(
          isLoading: true,
        ),
      );
      final email = event.email;
      final password = event.password;

      try {
        final userCreds = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);

        final user = userCreds.user;

        final images = await _getImages(user!.uid);

        emit(AppStateLoggedIn(user: user, images: images, isLoading: false));
      } on FirebaseAuthException catch (e) {
        emit(AppStateLoggedOut(isLoading: false, authError: AuthError.from(e)));
      }
    });

    on<AppEventGoToRegistration>((event, emit) {
      emit(const AppStateIsInRegisterationView(isLoading: false));
    });

    //* Handle Upload Images *//
    on<AppEventUploadImage>((event, emit) async {
      final currentUser = state.user;

      ///Log Out User if its Inavlid//
      if (currentUser == null) {
        emit(const AppStateLoggedOut(isLoading: false));
        return;
      }

      ///[Loading] Process///
      ///
      emit(
        AppStateLoggedIn(
          user: currentUser,
          images: state.images ?? [],
          isLoading: true,
        ),
      );

      final file = File(event.pathOfFileToUpload);

      ///................[Uploading The File] Here ..........///
      await uploadImage(file: file, userID: currentUser.uid);

      ///................[Grab The Images AFter Uploading] Here ..........///
      final images = await _getImages(currentUser.uid);
      emit(
        AppStateLoggedIn(
          user: currentUser,
          images: images,
          isLoading: false,
        ),
      );
    });

    ///..................[Delete USer Account From Firebase] .....................///
    on<AppEventDeleteAccount>((event, emit) async {
      final currentUser = FirebaseAuth.instance.currentUser;

      ///[Log Out] User if its Inavlid//
      if (currentUser == null) {
        emit(const AppStateLoggedOut(isLoading: false));
        return;
      }

      emit(
        AppStateLoggedIn(
          user: currentUser,
          images: state.images ?? [],
          isLoading: true,
        ),
      );

      try {
        ///[Delete User Folder] ///
        ///
        final folderContents =
            await FirebaseStorage.instance.ref(currentUser.uid).listAll();

        for (final item in folderContents.items) {
          await item.delete().catchError((_) {});
        }

        await FirebaseStorage.instance
            .ref(currentUser.uid)
            .delete()
            .catchError((_) {});

        await currentUser.delete();

        ///[Logg the User Out] ///
        ///
        await FirebaseAuth.instance.signOut();

        emit(const AppStateLoggedOut(isLoading: false));
      } on FirebaseAuthException catch (e) {
        emit(
          AppStateLoggedIn(
            user: currentUser,
            images: state.images ?? [],
            isLoading: false,
            authError: AuthError.from(e),
          ),
        );
      } on FirebaseException {
        ///Not Able to Delete The Folder Logged User Out ///
        emit(const AppStateLoggedOut(isLoading: false));

        ///
      }
    });

    on<AppEventLogoutUser>((event, emit) async {
      emit(const AppStateLoggedOut(isLoading: true));

      await FirebaseAuth.instance.signOut();

      emit(const AppStateLoggedOut(isLoading: false));
    });
  }

  Future<Iterable<Reference>> _getImages(String userID) =>
      FirebaseStorage.instance
          .ref(userID)
          .list()
          .then((result) => result.items);
}
