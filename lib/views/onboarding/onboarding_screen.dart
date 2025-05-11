import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cross_ide_android/viewmodels/onboarding/onboarding_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../widgets/onboarding/permission_step.dart';
import '../../widgets/onboarding/sdk_step.dart';
import '../../widgets/onboarding/wellcome_step.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  static const int _lastPageIndex = 2;

  @override
  void initState() {
    super.initState();
    /*  final viewModel = Provider.of<OnboardingViewmodel>(context, listen: false);

    viewModel.addListener(() {
      setState(() {
        viewModel.checkInternetConnection();
      });
    }); */
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToPreviousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _goToNextPage() {
    if (_currentPage < _lastPageIndex) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _completeOnboarding() {
    Navigator.of(context).pushReplacementNamed('/home');
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Consumer<OnboardingViewmodel>(
      builder: (_, vm, child) => Scaffold(
        body: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _currentPage = index;
            });
          },
          children: [
            const WellcomeStep(),
            PermissionStep(
              storageGranted: vm.storagePermissionGranted,
              installGranted: vm.installPermissionGranted,
              onTapInstall: vm.requestInstallPermission,
              onTapStorage: vm.requestStoragePermission,
            ),
            SdkStep(
              isLoading: vm.isLoadingSdk,
              versions: vm.sdkVersions,
              selected: vm.selectedVersion,
              onSelect: vm.selectVersion,
              hasInternet: vm.hasInternet,
              androidVersions: vm.androidSdkVersions,
              selectedAndroid: vm.selectedAndroidVersion,
              onSelectAndroid: vm.selectAndroidVersion,
            ),
          ],
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              if (_currentPage > 0)
                IconButton(
                  onPressed: _goToPreviousPage,
                  icon: const Icon(Icons.arrow_back_ios_new_rounded),
                  color: Colors.white,
                  padding: const EdgeInsets.all(15),
                  style: IconButton.styleFrom(
                    backgroundColor: colors.secondary,
                  ),
                )
              else
                const SizedBox(width: 56),
              const Spacer(),
              SmoothPageIndicator(
                controller: _pageController,
                count: _lastPageIndex + 1,
                effect: WormEffect(
                  dotColor: colors.onPrimary,
                  activeDotColor: colors.secondary,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () {
                  /*  if (_currentPage == 1 && (!vm.hasBootStrap)) {
                    final snackBar = SnackBar(
                      elevation: 0,
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Colors.transparent,
                      content: AwesomeSnackbarContent(
                        color: colors.primary,
                        title: 'Bootstrap',
                        message:
                            'Por favor, instale o bootstrap para continuar.',
                        contentType: ContentType.warning,
                      ),
                    );
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(snackBar);
                    return;
                  } */
                  if (_currentPage == 1 &&
                      (!vm.storagePermissionGranted ||
                          !vm.installPermissionGranted)) {
                    final snackBar = SnackBar(
                      elevation: 0,
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Colors.transparent,
                      content: AwesomeSnackbarContent(
                        color: colors.primary,
                        title: 'Permissão',
                        message:
                            'Por favor, conceda todas as permissões para continuar.',
                        contentType: ContentType.warning,
                      ),
                    );
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(snackBar);
                    return;
                  }
                  if (_currentPage == _lastPageIndex) {
                    _completeOnboarding();
                  } else {
                    _goToNextPage();
                  }
                },
                icon: Icon(
                  _currentPage == _lastPageIndex
                      ? Icons.check_rounded
                      : Icons.arrow_forward_ios_rounded,
                ),
                color: Colors.white,
                padding: const EdgeInsets.all(15),
                style: IconButton.styleFrom(
                  backgroundColor: colors.secondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
