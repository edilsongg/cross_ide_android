import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppBar(
        title: Text(
          'Configurações',
          style: textStyle.titleLarge,
        ),
        leading: IconButton(
          style: IconButton.styleFrom(
            backgroundColor: colors.secondaryContainer,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Gap(40),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text(
              'Configurar',
              style: textStyle.titleMedium,
            ),
          ),
          const Gap(40),
          ListTile(
            title: Text(
              'Tema',
              style: textStyle.titleLarge,
            ),
            subtitle: const Text(
              'Configurações do Tema',
            ),
            onTap: () => Navigator.pushNamed(context, '/general_settings'),
          ),
          const Gap(20),
          ListTile(
            title: Text(
              'Editor',
              style: textStyle.titleLarge,
            ),
            subtitle: const Text(
              'Configurações do Editor',
            ),
            onTap: () => Navigator.pushNamed(context, '/editor_settings'),
          ),
          const Gap(20),
          ListTile(
            title: Text(
              'Terminal',
              style: textStyle.titleLarge,
            ),
            subtitle: const Text(
              'Configurações do Terminal',
            ),
            onTap: () => Navigator.pushNamed(context, '/terminal_settings'),
          ),
          const Gap(20),
          ListTile(
            title: Text(
              'Executar e depurar',
              style: textStyle.titleLarge,
            ),
            subtitle: const Text(
              'Configurações de Compilação',
            ),
            onTap: () =>
                Navigator.pushNamed(context, '/execute_debug_settings'),
          ),
          const Gap(20),
          const Divider(),
        ],
      ),
    );
  }
}
