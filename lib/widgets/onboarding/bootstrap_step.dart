import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class BootstrapStep extends StatelessWidget {
  final bool hasBootstrap;

  final Function()? setupBootstrap;

  const BootstrapStep({
    super.key,
    required this.hasBootstrap,
    this.setupBootstrap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Gap(100),
        const Text(
          "Bootstrap",
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
        ),
        const Text(
          "O FlutterIDE requer que o bootstrap seja instalado",
        ),
        const SizedBox(height: 80),
        // Permissão de armazenamento
        GestureDetector(
          onTap: hasBootstrap ? null : () => setupBootstrap?.call(),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 60),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: hasBootstrap
                    ? colors.secondaryContainer
                    : colors.secondaryContainer.withOpacity(0.3)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bootstrap',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Necessário para o ambiente do terminal.',
                      ),
                    ],
                  ),
                ),
                hasBootstrap
                    ? const Icon(
                        Icons.check_circle_rounded,
                        color: Colors.green,
                      )
                    : Icon(
                        Icons.check_circle_outline_rounded,
                        color: Colors.grey[500],
                      ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
