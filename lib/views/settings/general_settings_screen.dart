import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

import '../../utils/enums_util.dart';
import '../../viewmodels/settings/settings_viewmodel.dart';

class GeneralSettingsScreen extends StatefulWidget {
  const GeneralSettingsScreen({super.key});

  @override
  State<GeneralSettingsScreen> createState() => _GeneralSettingsScreenState();
}

class _GeneralSettingsScreenState extends State<GeneralSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    final bool systemDark =
        MediaQuery.platformBrightnessOf(context) == Brightness.dark;

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppBar(
        title: const Text('Tema'),
        leading: IconButton(
          style: IconButton.styleFrom(
            backgroundColor: colors.secondaryContainer,
          ),
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
      ),
      body: Consumer<SettingsViewModel>(
        builder: (context, vm, child) {
          final selected = vm.selectedTheme;

          // Modos atuais
          // final bool followSystem = selected == ThemeOption.dark;
          final bool manualDarkMode = selected == ThemeOption.dark;
          final bool useAmoled = selected == ThemeOption.darkAmoled;

          final bool isDarkActive = (useAmoled && systemDark) || manualDarkMode;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Gap(40),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  'Configurações do Tema',
                  style: textStyle.titleMedium,
                ),
              ),
              const Gap(40),

              /*    Card(
                color: colors.primaryContainer,
                margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20),
                    bottom: Radius.circular(10),
                  ),
                ),
                child: SwitchListTile(
                  secondary: const Icon(Icons.palette),
                  title: const Text('Tema do Sistema'),
                  subtitle:
                      const Text('Use as configurações de tema do dispositivo'),
                  value: followSystem,
                  onChanged: (v) {
                    vm.select(v ? ThemeOption.system : ThemeOption.light);
                  },
                ),
              ),
 */

              Card(
                elevation: 0,
                color: colors.secondaryContainer,
                margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20),
                    bottom: Radius.circular(10),
                  ),
                ),
                child: SwitchListTile(
                  secondary: const Icon(Icons.dark_mode),
                  title: Text(
                    'Modo Escuro',
                    style: textStyle.titleMedium,
                  ),
                  subtitle: Text(
                    'Modo Escuro está ${manualDarkMode ? 'ativo' : 'inativo'}',
                  ),
                  value: isDarkActive,
                  onChanged: selected == ThemeOption.materialYou
                      ? null
                      : (v) {
                          vm.selectTheme(
                              v ? ThemeOption.dark : ThemeOption.light);
                        },
                ),
              ),
              Card(
                elevation: 0,
                color: colors.secondaryContainer,
                margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                child: SwitchListTile(
                  secondary: const Icon(Icons.opacity),
                  title: Text(
                    'Modo Escuro AMOLED',
                    style: textStyle.titleMedium,
                  ),
                  subtitle: const Text(
                    'Só disponível em modo escuro',
                  ),
                  value: useAmoled,
                  onChanged: selected == ThemeOption.materialYou ||
                          !isDarkActive
                      ? null
                      : (v) {
                          vm.selectTheme(
                              v ? ThemeOption.darkAmoled : ThemeOption.dark);
                        },
                ),
              ),
              Card(
                elevation: 0,
                color: colors.secondaryContainer,
                margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(20),
                    top: Radius.circular(10),
                  ),
                ),
                child: SwitchListTile(
                  secondary: const Icon(Icons.palette),
                  title: Text(
                    'Cores Dinâmicas',
                    style: textStyle.titleMedium,
                  ),
                  subtitle: const Text('Extraídas do papel de parede'),
                  value: selected == ThemeOption.materialYou,
                  onChanged: (v) {
                    vm.selectTheme(
                        v ? ThemeOption.materialYou : ThemeOption.light);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
