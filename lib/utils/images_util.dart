import 'package:flutter/material.dart';

const flutterIDELogo = 'assets/logo.png';

Future<void> precacheCache(BuildContext context) async {
  for (final asset in [
    flutterIDELogo,
  ]) {
    await precacheImage(AssetImage(asset), context);
  }
}
