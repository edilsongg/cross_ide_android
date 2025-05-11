import 'package:flutter/material.dart';

import '../../utils/images_util.dart' as images;

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    Future.wait([
      images.precacheCache(context),
      Future.delayed(const Duration(seconds: 2)),
    ]).whenComplete(() {
      Navigator.of(context).pushReplacementNamed('/onboarding');
    });
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    return Material(
      color: colors.surface,
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FlutterLogo(),
          /*  const Gap(35),
          Text(
            'Flutter IDE Android',
            style: GoogleFonts.lemon(
              fontSize: 47.5,
            ),
          ),
          const Gap(7),
          Image.asset('assets/logo.png'), */
        ],
      ),
    );
  }
}
