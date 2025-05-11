import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class PermissionStep extends StatelessWidget {
  final bool storageGranted;
  final bool installGranted;
  final Function()? onTapStorage;
  final Function()? onTapInstall;
  const PermissionStep({
    super.key,
    required this.storageGranted,
    required this.installGranted,
    this.onTapStorage,
    this.onTapInstall,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Gap(100),
        const Text(
          "Permissões",
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
        ),
        const Text(
          "O FlutterIDE requer as seguintes permissões",
        ),
        const SizedBox(height: 80),
        // Permissão de armazenamento
        GestureDetector(
          onTap: storageGranted ? null : () => onTapStorage?.call(),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 60),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: storageGranted
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
                        'Armazenamento',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Necessário para acessar os\narquivos do projeto.',
                      ),
                    ],
                  ),
                ),
                storageGranted
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
        const SizedBox(height: 20),
        // Permissão para instalar pacotes
        GestureDetector(
          onTap: installGranted ? null : () => onTapInstall?.call(),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 60),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: installGranted
                    ? colors.secondaryContainer
                    : colors.secondaryContainer.withOpacity(0.3)
                /*   border: Border.all(
                color: Colors.blueGrey,
              ), */
                ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Instalar pacotes',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Permitir a instalação de APKs\nconstruídos com FlutterIDE.',
                      ),
                    ],
                  ),
                ),
                installGranted
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
