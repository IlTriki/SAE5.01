import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:open_mail_app/open_mail_app.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:get/get.dart';

Future<void> openLink(String url) async {
  if (!await launchUrlString(url)) {
    throw Exception('Could not launch $url');
  }
}

Future<void> openEmailApp(BuildContext context) async {
  // Android: Will open mail app or show native picker.
  // iOS: Will open mail app if single mail app found.
  var result = await OpenMailApp.openMailApp();

  // If no mail apps found, show error
  if (!result.didOpen && !result.canOpen) {
    showNoMailAppsDialog(context);

    // iOS: if multiple mail apps found, show dialog to select.
    // There is no native intent/default app system in iOS so
    // you have to do it yourself.
  } else if (!result.didOpen && result.canOpen) {
    showDialog(
      context: context,
      builder: (_) {
        return MailAppPickerDialog(
          mailApps: result.options,
        );
      },
    );
  }
}

void showNoMailAppsDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(Translate.of(context).dialogTitle),
        content: Text(Translate.of(context).dialogDescription),
        actions: <Widget>[
          FilledButton(
            child: Text(Translate.of(context).dialogButton),
            onPressed: () {
              Get.back();
            },
          )
        ],
      );
    },
  );
}
