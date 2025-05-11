import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/settings/settings_viewmodel.dart';

class TerminalSettingsScreen extends StatelessWidget {
  const TerminalSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textStyle = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppBar(
        title: Text(
          'Terminal',
          style: textStyle.titleLarge,
        ),
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
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Gap(40),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  'Configurações do editor',
                  style: textStyle.titleMedium,
                ),
              ),
              const Gap(12),
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
                  secondary: const Icon(Icons.android_rounded),
                  title: Text(
                    'Usar Shell do Sistema',
                    style: textStyle.titleMedium,
                  ),
                  subtitle: const Text(
                    "Se ativado, '/system/bin/sh' será utilizado no terminal ",
                  ),
                  value: vm.useSystemShell,
                  onChanged: (v) {
                    vm.toggleUseSystemShell(v);
                  },
                ),
              ),
              Card(
                elevation: 0,
                color: colors.secondaryContainer,
                margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(10),
                    bottom: Radius.circular(20),
                  ),
                ),
                child: ListTile(
                  title: Text(
                    'Dart Sever Analysis path',
                    style: textStyle.titleMedium,
                  ),
                  subtitle: const Text(
                    "Path do Sever Analysis'/data/data/com.termux/files/usr/opt/flutter/bin/cache/dart-sdk'",
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
