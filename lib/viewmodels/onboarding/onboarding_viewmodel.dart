import 'dart:async';
import 'dart:convert';

import 'package:cross_ide_android/models/sdk_version.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';

import '../../utils/enums_util.dart';
import '../../utils/network_util.dart';
import '../../utils/sdk_util.dart';

class OnboardingViewmodel extends ChangeNotifier {
/*   final NetworkUtil _networkInfo;
  NetworkInfo get networkInfo => _networkInfo;
 */
  final NetworkUtil _networkUtil;
  // Estado do onboarding
  OnboardingStep _currentStep = OnboardingStep.installApps;
  OnboardingStep get currentStep => _currentStep;

  bool _installPermissionGranted = false;
  bool get installPermissionGranted => _installPermissionGranted;

  bool _storagePermissionGranted = false;
  bool get storagePermissionGranted => _storagePermissionGranted;

  final bool _hasBootStrap = false;
  bool get hasBootStrap => _hasBootStrap;

  bool _isLoadingSdk = false;
  bool get isLoadingSdk => _isLoadingSdk;

  List<SdkVersionModel> _sdkVersions = [];
  List<SdkVersionModel> get sdkVersions => _sdkVersions;

  List<SdkVersionModel> _androidSdkVersions = [];
  List<SdkVersionModel> get androidSdkVersions => _androidSdkVersions;

  SdkVersionModel? _selectedVersion;
  SdkVersionModel? get selectedVersion => _selectedVersion;

  SdkVersionModel? _selectedAndroidVersion;
  SdkVersionModel? get selectedAndroidVersion => _selectedAndroidVersion;

  bool _hasInternet = false;
  bool get hasInternet => _hasInternet;
  StreamSubscription<bool>? _connectivitySub;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  OnboardingViewmodel({NetworkUtil? networkUtil})
      : _networkUtil = networkUtil ?? NetworkUtil() {
    init();
  }

  Future<void> checkInternetConnection() async {
    _hasInternet = await _networkUtil.checkInitialConnection();
    notifyListeners();

    // 2. Escuta mudanças contínuas
    _connectivitySub = _networkUtil.onConnectivityChanged.listen((status) {
      if (_hasInternet != status) {
        _hasInternet = status;
        notifyListeners();
      }
    });
  }

  Future<void> init() async {
    // 1. Checa estado inicial
    await checkInternetConnection();
    checkPermissions();
    await loadSdkVersions();
    await loadAndroidSdkVersions();
  }

  Future<List<SdkVersionModel>> fetchSdkVersions() async {
    final uri = Uri.parse(
      'https://api.github.com/repos/mumumusuc/termux-flutter/releases',
    );
    final response = await http.get(
      uri,
      headers: {'Accept': 'application/vnd.github.v3+json'},
    );

    if (response.statusCode == 200) {
      final List jsonList = json.decode(response.body);
      final releases =
          jsonList.map((json) => SdkVersionModel.fromJson(json)).toList();

      return releases
          .where(
              (release) => isVersionGreaterOrEqual(release.tagName, '3.19.0'))
          .toList();
    } else {
      throw Exception('Failed to load releases');
    }
  }

  Future<List<SdkVersionModel>> fetchAndroidSdkVersions() async {
    final uri = Uri.parse(
      'https://api.github.com/repos/lzhiyong/android-sdk-tools/releases',
    );
    final response = await http.get(
      uri,
      headers: {'Accept': 'application/vnd.github.v3+json'},
    );

    if (response.statusCode == 200) {
      final List jsonList = json.decode(response.body);

      final releases =
          jsonList.map((json) => SdkVersionModel.fromJson(json)).toList();

      //  print(releases);
      return releases
          .where(
              (release) => isVersionGreaterOrEqual(release.tagName, '3.19.0'))
          .toList();
    } else {
      throw Exception('Failed to load releases');
    }
  }

  Future<void> requestInstallPermission() async {
    // Em Android, pedir permissão de instalar fontes desconhecidas não é direto via permission_handler.
    // Suponha que usemos um método nativo. Aqui simulamos:
    final status = await Permission.requestInstallPackages.request();
    _installPermissionGranted = status.isGranted;
    // installPermissionGranted = true;
    if (!installPermissionGranted) {
      _errorMessage = 'Por favor, permita instalação de apps';
    } else {
      _errorMessage = null;
      _currentStep = OnboardingStep.storage;
    }
    notifyListeners();
  }

  Future<void> requestStoragePermission() async {
    final status = await Permission.manageExternalStorage.request();
    _storagePermissionGranted = status.isGranted;
    if (!storagePermissionGranted) {
      _errorMessage = 'Por favor, permita gerenciamento de armazenamento';
    } else {
      _errorMessage = null;
      _currentStep = OnboardingStep.sdkSelection;
    }
    notifyListeners();
  }

  Future<void> loadSdkVersions() async {
    _isLoadingSdk = true;
    notifyListeners();
    final result = await fetchSdkVersions();

    _selectedVersion = result.firstOrNull;
    _sdkVersions = result;

    _isLoadingSdk = false;
    notifyListeners();
  }

  Future<void> loadAndroidSdkVersions() async {
    _isLoadingSdk = true;
    notifyListeners();
    final result = await fetchAndroidSdkVersions();

    _selectedAndroidVersion = result.firstOrNull;
    _androidSdkVersions = result;

    // print(result.fold(ifLeft, ifRight));
    _isLoadingSdk = false;
    notifyListeners();
  }

  // Função para verificar as permissões
  Future<void> checkPermissions() async {
    PermissionStatus storageStatus =
        await Permission.manageExternalStorage.status;
    PermissionStatus installStatus =
        await Permission.requestInstallPackages.status;

    _storagePermissionGranted = storageStatus.isGranted;
    _installPermissionGranted = installStatus.isGranted;

    notifyListeners();
  }

  void selectVersion(SdkVersionModel v) {
    _selectedVersion = v;
    notifyListeners();
  }

  void selectAndroidVersion(SdkVersionModel v) {
    _selectedAndroidVersion = v;
    notifyListeners();
  }

  @override
  void dispose() {
    _connectivitySub?.cancel();
    super.dispose();
  }

  bool canComplete() => selectedVersion != null && hasInternet;
}
