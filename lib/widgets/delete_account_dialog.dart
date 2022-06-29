import 'package:flutter/material.dart' show BuildContext;
import 'package:photo_cloud/widgets/genric_dialog.dart';

Future<bool> showDeleteAccountDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: 'Delete Account',
    content: 'Are sure to Delete you account',
    optionsBuilder: () => {
      'Cancel': false,
      'Delete Account': true,
    },
  ).then((value) => value ?? false);
}
