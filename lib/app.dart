import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_cloud/logic/app_bloc.dart';
import 'package:photo_cloud/logic/app_events.dart';
import 'package:photo_cloud/logic/app_state.dart';
import 'package:photo_cloud/screens/home.dart';
import 'package:photo_cloud/screens/login_screen.dart';
import 'package:photo_cloud/screens/register_screen.dart';
import 'package:photo_cloud/widgets/error_dialog.dart';
import 'package:photo_cloud/widgets/loading/loading_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AppBloc()..add(const AppEventInitializeApp()),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          primarySwatch: Colors.purple,
        ),
        home: BlocConsumer<AppBloc, AppState>(
          listener: (context, appState) {
            if (appState.isLoading) {
              LoadingScreen.instance()
                  .show(context: context, text: 'Loading...');
            } else {
              LoadingScreen.instance().hide();
            }
            final authError = appState.authError;
            if (authError != null) {
              showAuthErrorDialog(context: context, authError: authError);
            }
          },
          builder: (context, appState) {
            if (appState is AppStateLoggedOut) {
              return const LoginScreen();
            } else if (appState is AppStateLoggedIn) {
              return const HomeScreen();
            } else if (appState is AppStateIsInRegisterationView) {
              return const RegisterScreen();
            } else {
              return Container(
                child: const Text('Incorrect State 404'),
              );
            }
          },
        ),
      ),
    );
  }
}
