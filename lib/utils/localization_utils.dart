import 'package:flutter/material.dart';
import 'package:protein_tracker/app_localizations.dart';

String translatedText(text, BuildContext context) {
  return AppLocalizations.of(context).translate(text);
}
