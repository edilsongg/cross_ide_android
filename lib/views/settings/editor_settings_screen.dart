import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

import '../../utils/common_dialogs_util.dart';
import '../../viewmodels/settings/settings_viewmodel.dart';
import '../../widgets/settings/animated_slider.dart';

class EditorSettingsScreen extends StatefulWidget {
  const EditorSettingsScreen({super.key});

  @override
  State<EditorSettingsScreen> createState() => _EditorSettingsScreenState();
}

class _EditorSettingsScreenState extends State<EditorSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    final vm = context.read<SettingsViewModel>(); // pega o provider sem escutar
    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppBar(
        title: const Text('Editor'),
        leading: IconButton(
          style: IconButton.styleFrom(
            backgroundColor: colors.secondaryContainer,
          ),
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Gap(40),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              'Configurações do Editor',
              style: textStyle.titleMedium,
            ),
          ),
          const SizedBox(height: 12),
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
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 8),
              subtitle: Row(
                children: [
                  const Icon(Icons.format_size_rounded, size: 24),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tamanho da Fonte',
                          style: textStyle.titleMedium,
                        ),
                        Selector<SettingsViewModel, double>(
                          selector: (_, vm) =>
                              vm.fontSize, // seleciona só o fontSize
                          builder: (context, fontSize, child) {
                            // recebe o valor selecionado

                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: AnimatedSlider(
                                    // padding: const EdgeInsets.symmetric(
                                    //    horizontal: 8),
                                    //  year2023: false,
                                    min: 8,
                                    max: 24,
                                    divisions: 16,
                                    value: fontSize,
                                    barColor: colors.primary,
                                    height: 40,
                                    barWidth: 4,
                                    leftFillColor:
                                        colors.primary.withOpacity(0.8),
                                    rightFillColor:
                                        colors.primary.withOpacity(0.4),
                                    onChange: vm.setFontSize,
                                  ),
                                ),
                                const Gap(10),
                                SizedBox(
                                  width: 40,
                                  child: Text(
                                    '${fontSize.toInt()} sp',
                                    style: textStyle.titleSmall,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Card(
            elevation: 0,
            color: colors.secondaryContainer,
            margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
            child: Selector<SettingsViewModel, String>(
                selector: (_, vm) => vm.fontFamily, // seleciona só o fontSize
                builder: (context, fontFamily, child) {
                  return ListTile(
                    leading: const Icon(Icons.font_download_rounded, size: 24),
                    title: Text(
                      'Estilo da Fonte',
                      style: textStyle.titleMedium,
                    ),
                    subtitle: Text(fontFamily),
                    onTap: () async {
                      final newFamily = await showFontFamilyDialog(
                        context,
                        currentFamily: fontFamily,
                        families: [
                          'FiraCode',
                          'Roboto',
                          'OpenSans',
                          'SpaceMono',
                          'CourierPrime'
                        ],
                      );
                      if (newFamily != null) vm.setFontFamily(newFamily);
                    },
                  );
                }),
          ),
          Card(
            elevation: 0,
            color: colors.secondaryContainer,
            margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Selector<SettingsViewModel, bool>(
                selector: (_, vm) =>
                    vm.fontLigatures, // seleciona só o fontSize
                builder: (context, fontLigatures, child) {
                  return SwitchListTile(
                    secondary: const Icon(Icons.line_axis_rounded),
                    title: Text(
                      'Ligaduras de Fonte',
                      style: textStyle.titleMedium,
                    ),
                    subtitle: Text(
                      'Ligaduras de fonte está ${fontLigatures ? 'ativo' : 'inativo'}',
                    ),
                    value: fontLigatures,
                    onChanged: (v) {
                      vm.toggleFontLigadures(v);
                    },
                  );
                }),
          ),
          Card(
            elevation: 0,
            color: colors.secondaryContainer,
            margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
            child: Selector<SettingsViewModel, List<String>>(
                selector: (_, vm) =>
                    vm.customSymbols, // seleciona só o fontSize
                builder: (context, customSymbols, child) {
                  return ListTile(
                    leading: const Icon(Icons.code_rounded, size: 24),
                    title: Text(
                      'Simbolos Customizados',
                      style: textStyle.titleMedium,
                    ),
                    subtitle: Text(vm.customSymbols.isEmpty
                        ? 'Nenhum símbolo definido'
                        : customSymbols.join(', ')),
                    onTap: () async {
                      final symbols = await showCustomSymbolsDialog(
                        context,
                        initialSymbols: customSymbols,
                      );
                      if (symbols != null) vm.setCustomSymbols(symbols);
                    },
                  );
                }),
          ),
          Card(
            elevation: 0,
            color: colors.secondaryContainer,
            margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Selector<SettingsViewModel, bool>(
                selector: (_, vm) => vm.lineNumbers, // seleciona só o fontSize
                builder: (context, lineNumbers, child) {
                  return SwitchListTile(
                    secondary: const Icon(Icons.line_weight_rounded),
                    title: Text(
                      'Mostrar Números de Linha',
                      style: textStyle.titleMedium,
                    ),
                    subtitle: Text(
                      'Números de linha está ${lineNumbers ? 'ativo' : 'inativo'}',
                    ),
                    value: lineNumbers,
                    onChanged: (v) {
                      vm.toggleLineNumbers(v);
                    },
                  );
                }),
          ),
          Card(
            elevation: 0,
            color: colors.secondaryContainer,
            margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Selector<SettingsViewModel, bool>(
                selector: (_, vm) =>
                    vm.lineHighlight, // seleciona só o fontSize
                builder: (context, lineHighlight, child) {
                  return SwitchListTile(
                    secondary: const Icon(Icons.highlight_alt_rounded),
                    title: Text(
                      'Mostrar Destaques de Linha',
                      style: textStyle.titleMedium,
                    ),
                    subtitle: Text(
                      'Destaque de linha está ${lineHighlight ? 'ativo' : 'inativo'}',
                    ),
                    value: lineHighlight,
                    onChanged: (v) {
                      vm.toggleLineHighlight(v);
                    },
                  );
                }),
          ),
          Card(
            elevation: 0,
            color: colors.secondaryContainer,
            margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Selector<SettingsViewModel, bool>(
                selector: (_, vm) => vm.codeBlock, // seleciona só o fontSize
                builder: (context, codeBlock, child) {
                  return SwitchListTile(
                    secondary: const Icon(Icons.linear_scale_rounded),
                    title: Text(
                      'Bloco de Codigo',
                      style: textStyle.titleMedium,
                    ),
                    subtitle: Text(
                      'Bloco de Codigo está ${codeBlock ? 'ativo' : 'inativo'}',
                    ),
                    value: codeBlock,
                    onChanged: (v) {
                      vm.toggleCodeBlock(v);
                    },
                  );
                }),
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
            child: Selector<SettingsViewModel, bool>(
                selector: (_, vm) => vm.autoSave, // seleciona só o fontSize
                builder: (context, autoSave, child) {
                  return SwitchListTile(
                    secondary: const Icon(Icons.save_rounded),
                    title: Text(
                      'Salvar Automaticamente',
                      style: textStyle.titleMedium,
                    ),
                    subtitle: Text(
                      'Salvar Automaticamente está ${autoSave ? 'ativo' : 'inativo'}',
                    ),
                    value: autoSave,
                    onChanged: (v) {
                      vm.toggleAutoSave(v);
                    },
                  );
                }),
          ),
        ],
      ),
    );
  }
}
