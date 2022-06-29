import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:photo_cloud/logic/app_bloc.dart';
import 'package:photo_cloud/logic/app_events.dart';
import 'package:photo_cloud/widgets/delete_account_dialog.dart';
import 'package:photo_cloud/widgets/logout_dialog.dart';

enum MenuAction { logout, deleteAccount }

class MainMenuPopUP extends StatelessWidget {
  const MainMenuPopUP({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<MenuAction>(onSelected: (value) async {
      switch (value) {
        case MenuAction.logout:
          final shouldLogout = await showLogoutAccountDialog(context);
          if (shouldLogout) {
            context.read<AppBloc>().add(const AppEventLogoutUser());
          }
          break;
        case MenuAction.deleteAccount:
          final shouldDeleteAccount = await showDeleteAccountDialog(context);
          if (shouldDeleteAccount) {
            context.read<AppBloc>().add(const AppEventDeleteAccount());
          }
          break;
      }
    }, itemBuilder: (context) {
      return [
        const PopupMenuItem<MenuAction>(
            value: MenuAction.logout, child: Text('Logout')),
        const PopupMenuItem<MenuAction>(
            value: MenuAction.deleteAccount, child: Text('Delete Account'))
      ];
    });
  }
}
