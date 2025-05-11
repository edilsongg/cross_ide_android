import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:get/utils.dart';
import 'package:global_repository/global_repository.dart';

///
class UniqueUtil {
  UniqueUtil._();
  static Future<String> getDevicesId() async {
    if (GetPlatform.isWeb) {
      return 'web';
    }
    if (GetPlatform.isDesktop) {
      final betterNames = {
        'macos': 'macOS',
      };

      return betterNames[Platform.operatingSystem] ?? Platform.operatingSystem;
    } else if (GetPlatform.isIOS) {
      return 'iOS';
    } else {
      props ??= await exec('getprop');
      // print(props);
      // print(getValueFromProps('ro.product.model'));
      final String marketNmae = getValueFromProps('ro.product.marketname');
      return marketNmae.isNotEmpty ? marketNmae : getValueFromProps('ro.product.model');
    }
  }

  static Future<String> getUniqueKey() async {
    String? dataPath = RuntimeEnvir.configPath;
    File file;
    if (Platform.isAndroid) {
      file = File('${RuntimeEnvir.filesPath}/unique.txt');
    } else {
      file = File('$dataPath/unique.txt');
    }
    if (file.existsSync()) {
      return file.readAsStringSync();
    }
    await generateUniqueKey();
    return getUniqueKey();
  }

  static Future<void> generateUniqueKey() async {
    String? dataPath = RuntimeEnvir.configPath;
    File file;
    if (Platform.isAndroid) {
      file = File('${RuntimeEnvir.filesPath}/unique.txt');
    } else {
      file = File('$dataPath/unique.txt');
    }
    await file.writeAsString(shortHash(() {}));
  }

  static String? props;
  static String getValueFromProps(String key) {
    final List<String> tmp = props!.split('\n');
    for (final String line in tmp) {
      if (line.contains(key)) {
        return line.replaceAll(RegExp('.*\\]: |\\[|\\]'), '');
      }
    }
    return '';
    // print(key);
  }
}
