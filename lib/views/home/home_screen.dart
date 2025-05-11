import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Flutter IDE Android',
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 60),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /*    ElevatedButton.icon(
                icon: const Icon(Icons.code),
                label: const Text('Editor de Código'),
                onPressed: () => Navigator.pushNamed(context, '/editor'),
              ),
              const SizedBox(height: 16), */
              Image.asset(
                'assets/logo.png',
                width: 180,
                height: 180,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  'Começe um Novo Projeto',
                  style: textStyle.titleMedium,
                ),
              ),
              const Gap(40),
              Card(
                elevation: 0,
                color: colors.secondaryContainer,
                margin: const EdgeInsets.symmetric(
                  vertical: 2,
                  horizontal: 0,
                ),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20),
                    bottom: Radius.circular(10),
                  ),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 20,
                  ),
                  leading: const Icon(
                    Icons.add_rounded,
                    size: 24,
                  ),
                  title: Text(
                    'Novo Projeto',
                    style: textStyle.titleMedium,
                  ),
                  onTap: () => Navigator.pushNamed(context, '/terminal'),
                ),
              ),
              Card(
                elevation: 0,
                color: colors.secondaryContainer,
                margin: const EdgeInsets.symmetric(
                  vertical: 2,
                  horizontal: 0,
                ),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(10),
                    bottom: Radius.circular(10),
                  ),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 20,
                  ),
                  leading: const Icon(
                    Icons.folder_outlined,
                    size: 24,
                  ),
                  title: Text(
                    'Abrir Projeto Existente',
                    style: textStyle.titleMedium,
                  ),
                  onTap: () => Navigator.pushNamed(context, '/projects'),
                ),
              ),
              Card(
                elevation: 0,
                color: colors.secondaryContainer,
                margin: const EdgeInsets.symmetric(
                  vertical: 2,
                  horizontal: 0,
                ),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(10),
                    bottom: Radius.circular(10),
                  ),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 20,
                  ),
                  leading: const Icon(
                    Icons.linear_scale_rounded,
                    size: 24,
                  ),
                  title: Text(
                    'Clonar Repositorio',
                    style: textStyle.titleMedium,
                  ),
                  onTap: () => Navigator.pushNamed(context, '/terminal'),
                ),
              ),
              Card(
                elevation: 0,
                color: colors.secondaryContainer,
                margin: const EdgeInsets.symmetric(
                  vertical: 2,
                  horizontal: 0,
                ),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(10),
                    bottom: Radius.circular(10),
                  ),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 20,
                  ),
                  leading: const Icon(
                    Icons.terminal_outlined,
                    size: 24,
                  ),
                  title: Text(
                    'Terminal',
                    style: textStyle.titleMedium,
                  ),
                  onTap: () => Navigator.pushNamed(context, '/terminal'),
                ),
              ),
              Card(
                elevation: 0,
                color: colors.secondaryContainer,
                margin: const EdgeInsets.symmetric(
                  vertical: 2,
                  horizontal: 0,
                ),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(10),
                    bottom: Radius.circular(20),
                  ),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 20,
                  ),
                  leading: const Icon(
                    Icons.settings_outlined,
                    size: 24,
                  ),
                  title: Text(
                    'Configurações',
                    style: textStyle.titleMedium,
                  ),
                  onTap: () => Navigator.pushNamed(context, '/settings'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
