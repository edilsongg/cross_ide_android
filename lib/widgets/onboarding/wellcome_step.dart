import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class WellcomeStep extends StatelessWidget {
  const WellcomeStep({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset('assets/logo.png'),
        const Gap(40),
        const Text(
          'Bem-vindo',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 10),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Text(
            'Construa aplicativos multiplataforma direto do seu dispositivo Android.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }
}
