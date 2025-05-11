// lib/views/terminal_screen.dart

import 'package:cross_ide_android/viewmodels/terminal/terminal_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../widgets/terminal/xterm_bottom_bar.dart';
import '../../widgets/terminal/xterm_wrapper.dart';

class TerminalScreen extends StatelessWidget {
  const TerminalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    return Consumer<TerminalViewModel>(
      builder: (context, vm, child) {
        return Scaffold(
          drawer: Drawer(
            child: SafeArea(
              child: Column(
                children: [
                  ListTile(
                    leading: const Text('Sessões'),
                    trailing: const Icon(Icons.add),
                    onTap: () {
                      vm.addTerminal(context);
                      Navigator.of(context).pop(); // fecha drawer
                    },
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: vm.terms.length,
                      itemBuilder: (context, i) {
                        final isSelected = vm.currentIndex == i;
                        return Card(
                          color: isSelected
                              ? colors.secondaryContainer
                              : colors.secondaryContainer.withOpacity(0.3),
                          margin: const EdgeInsets.symmetric(
                              vertical: 2, horizontal: 5),
                          child: ListTile(
                            title: Text('Terminal ${i + 1}'),
                            selected: isSelected,
                            onTap: () {
                              vm.switchTerminal(i);
                              Navigator.of(context).pop(); // fecha drawer
                            },
                            onLongPress: () async {
                              final shouldDelete = await showDialog<bool>(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: Text('Fechar Terminal ${i + 1}?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(ctx).pop(false),
                                      child: const Text('Cancelar'),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(ctx).pop(true),
                                      child: const Text('Fechar'),
                                    ),
                                  ],
                                ),
                              );
                              if (shouldDelete == true) {
                                vm.removeTerminal(i);
                                // Se fechou o terminal atualmente selecionado,
                                // pode ser legal resetar a tela ou manter índice válido.
                              }
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  const Divider(),
                  // Botão para adicionar novo terminal
                ],
              ),
            ),
          ),
          appBar: AppBar(
            title: const Text('Terminal'),
            leading: Builder(
              builder: (ctx) => IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () => Scaffold.of(ctx).openDrawer()),
            ),
          ),
          body: SafeArea(
            child: vm.terms.isEmpty
                ? const Center(child: Text('Nenhum terminal aberto'))
                : Column(
                    children: [
                      Expanded(
                        child: IndexedStack(
                          index: vm.currentIndex,
                          children: vm.terms.map((t) {
                            return XTermWrapper(
                              terminal: t.terminal,
                              pseudoTerminal: t.pty,
                              controller: t.controller,
                            );
                          }).toList(),
                        ),
                      ),
                      if (vm.terms.isNotEmpty)
                        XtermBottomBar(
                          pseudoTerminal: vm.terms[vm.currentIndex].pty,
                          terminal: vm.terms[vm.currentIndex].terminal,
                        ),
                    ],
                  ),
          ),
        );
      },
    );
  }
}
