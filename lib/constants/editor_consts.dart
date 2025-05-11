import 'package:flutter/material.dart';
import 'package:re_editor/re_editor.dart';

const EdgeInsetsGeometry kDefaultFindMargin = EdgeInsets.only(right: 10);
const double kDefaultFindPanelWidth = 360;
const double kDefaultFindPanelHeight = 36;
const double kDefaultReplacePanelHeight = kDefaultFindPanelHeight * 2;
const double kDefaultFindIconSize = 16;
const double kDefaultFindIconWidth = 30;
const double kDefaultFindIconHeight = 30;
const double kDefaultFindInputFontSize = 13;
const double kDefaultFindResultFontSize = 12;
const EdgeInsetsGeometry kDefaultFindPadding =
    EdgeInsets.only(left: 5, right: 5, top: 2.5, bottom: 2.5);
const EdgeInsetsGeometry kDefaultFindInputContentPadding = EdgeInsets.only(
  left: 5,
  right: 5,
);

const List<CodePrompt> kStringPrompts = [
  CodeFieldPrompt(word: 'length', type: 'int'),
  CodeFieldPrompt(word: 'isEmpty', type: 'bool'),
  CodeFieldPrompt(word: 'isNotEmpty', type: 'bool'),
  CodeFieldPrompt(word: 'characters', type: 'Characters'),
  CodeFieldPrompt(word: 'hashCode', type: 'int'),
  CodeFieldPrompt(word: 'codeUnits', type: 'List<int>'),
  CodeFieldPrompt(word: 'runes', type: 'Runes'),
  CodeFunctionPrompt(
      word: 'codeUnitAt', type: 'int', parameters: {'index': 'int'}),
  CodeFunctionPrompt(word: 'replaceAll', type: 'String', parameters: {
    'from': 'Pattern',
    'replace': 'String',
  }),
  CodeFunctionPrompt(word: 'contains', type: 'bool', parameters: {
    'other': 'String',
  }),
  CodeFunctionPrompt(word: 'split', type: 'List<String>', parameters: {
    'pattern': 'Pattern',
  }),
  CodeFunctionPrompt(word: 'endsWith', type: 'bool', parameters: {
    'other': 'String',
  }),
  CodeFunctionPrompt(word: 'startsWith', type: 'bool', parameters: {
    'other': 'String',
  })
];
