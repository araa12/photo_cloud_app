import 'package:flutter/material.dart' show BuildContext;
import 'package:photo_cloud/widgets/genric_dialog.dart';

Future<bool> showLogoutAccountDialog(
  BuildContext context,
) {
  return showGenericDialog<bool>(
    context: context,
    title: 'Log out',
    content: 'Are sure to Log Out from App',
    optionsBuilder: () => {
      'Cancel': false,
      'Log out': true,
    },
  ).then((value) => value ?? false);
}
