import 'package:flutter/material.dart' show BuildContext;
import 'package:photo_cloud/auth/auth_error.dart';
import 'package:photo_cloud/widgets/genric_dialog.dart';

Future<void> showAuthErrorDialog({
  required BuildContext context,
  required AuthError authError,
}) {
  return showGenericDialog<void>(
    context: context,
    title: authError.title,
    content: authError.errorDescription,
    optionsBuilder: () => {
      'Ok': false,
    },
  );
}
