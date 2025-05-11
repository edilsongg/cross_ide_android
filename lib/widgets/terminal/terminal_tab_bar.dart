import 'package:cross_ide_android/viewmodels/terminal/terminal_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TerminalTabBar extends StatelessWidget {
  const TerminalTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<TerminalViewModel>();
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (var i = 0; i < vm.terms.length; i++) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: ChoiceChip(
                label: Row(
                  children: [
                    Text('Term ${i + 1}'),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () => vm.removeTerminal(i),
                      child: const Icon(Icons.close, size: 24),
                    ),
                  ],
                ),
                selected: vm.currentIndex == i,
                onSelected: (_) => vm.switchTerminal(i),
              ),
            ),
          ],
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () {
              vm.addTerminal(context);
            },
          ),
        ],
      ),
    );
  }
}
