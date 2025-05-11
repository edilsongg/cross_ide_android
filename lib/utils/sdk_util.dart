bool isVersionGreaterOrEqual(String version, String minimumVersion) {
  if (version.startsWith('v')) {
    version = version.substring(1);
  }
  if (minimumVersion.startsWith('v')) {
    minimumVersion = minimumVersion.substring(1);
  }

  final List<int> versionNums =
      version.split('.').map((e) => int.tryParse(e) ?? 0).toList();
  final List<int> minimumNums =
      minimumVersion.split('.').map((e) => int.tryParse(e) ?? 0).toList();

  final int length =
      [versionNums.length, minimumNums.length].reduce((a, b) => a > b ? a : b);
  while (versionNums.length < length) {
    versionNums.add(0);
  }
  while (minimumNums.length < length) {
    minimumNums.add(0);
  }

  for (int i = 0; i < length; i++) {
    if (versionNums[i] > minimumNums[i]) {
      return true;
    } else if (versionNums[i] < minimumNums[i]) {
      return false;
    }
  }

  return true;
}
