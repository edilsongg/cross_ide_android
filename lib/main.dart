import 'package:cross_ide_android/injection_container.dart';
import 'package:cross_ide_android/routes.dart';
import 'package:cross_ide_android/viewmodels/settings/settings_viewmodel.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:global_repository/global_repository.dart';
import 'package:provider/provider.dart';

import 'utils/enums_util.dart';
import 'utils/transitions_util.dart';
import 'viewmodels/terminal/terminal_viewmodel.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  RuntimeEnvir.initEnvirWithPackageName('com.termux');

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,
      child: Consumer<SettingsViewModel>(builder: (_, vm, __) {
        ThemeMode themeMode;
        switch (vm.selectedTheme) {
          case ThemeOption.materialYou:
            themeMode = ThemeMode.system;
            break;
          case ThemeOption.light:
            themeMode = ThemeMode.light;
            break;
          case ThemeOption.dark:
          case ThemeOption.darkAmoled:
            themeMode = ThemeMode.dark;
            break;
        }

        return DynamicColorBuilder(builder: (lightDynamic, darkDynamic) {
          final bool useDynamic = vm.selectedTheme == ThemeOption.materialYou &&
              lightDynamic != null &&
              darkDynamic != null;

          final ColorScheme lightScheme = useDynamic
              ? lightDynamic.harmonized()
              : ColorScheme.fromSeed(
                  seedColor: Colors.blueGrey, brightness: Brightness.light);
          ColorScheme darkScheme = useDynamic
              ? darkDynamic.harmonized().copyWith()
              : ColorScheme.fromSeed(
                  seedColor: Colors.blueGrey, brightness: Brightness.dark);
          if (vm.selectedTheme == ThemeOption.darkAmoled) {
            darkScheme = darkScheme.copyWith(surface: Colors.black);
          }

          return MaterialApp(
            debugShowCheckedModeBanner: false,
            themeMode: themeMode,
            theme: ThemeData(
              colorScheme: lightScheme,
              useMaterial3: true,
              splashColor: Colors.transparent,
              navigationBarTheme: NavigationBarThemeData(
                backgroundColor: lightScheme.surface,
              ),
              pageTransitionsTheme: PageTransitionsTheme(
                builders: {
                  for (final platform in TargetPlatform.values)
                    platform: const FadeTransitionsBuilder(),
                },
              ),
            ),
            darkTheme: ThemeData(
              colorScheme: darkScheme,
              useMaterial3: true,
              splashColor: Colors.transparent,
              navigationBarTheme: NavigationBarThemeData(
                backgroundColor: darkScheme.surface,
              ),
              pageTransitionsTheme: PageTransitionsTheme(
                builders: {
                  for (final platform in TargetPlatform.values)
                    platform: const FadeTransitionsBuilder(),
                },
              ),
            ),
            builder: (context, child) {
              final SystemUiOverlayStyle overlayStyle = SystemUiOverlayStyle(
                statusBarColor: themeMode == ThemeMode.dark
                    ? darkScheme.surface
                    : vm.selectedTheme == ThemeOption.materialYou
                        ? darkScheme.surface
                        : lightScheme.surface,
                statusBarIconBrightness: themeMode == ThemeMode.dark
                    ? Brightness.light
                    : vm.selectedTheme == ThemeOption.materialYou
                        ? Brightness.light
                        : Brightness.dark,
                systemNavigationBarColor: themeMode == ThemeMode.dark
                    ? darkScheme.surface
                    : vm.selectedTheme == ThemeOption.materialYou
                        ? darkScheme.surface
                        : lightScheme.surface,
                systemNavigationBarIconBrightness: themeMode == ThemeMode.dark
                    ? Brightness.light
                    : vm.selectedTheme == ThemeOption.materialYou
                        ? Brightness.light
                        : Brightness.dark,
              );
              return ChangeNotifierProvider<TerminalViewModel>(
                create: (context) =>
                    TerminalViewModel()..loadTerminals(context),
                child: AnnotatedRegion<SystemUiOverlayStyle>(
                  value: overlayStyle,
                  child: child!,
                ),
              );
            },
            initialRoute: '/',
            routes: routes,
          );
        });
      }),
    );
  }
}
