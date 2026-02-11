import 'package:datashield_frontend/Screens/games_screen.dart';
import 'package:datashield_frontend/themes/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'Screens/landing_page.dart';
import 'Screens/homescreen.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final themeMode = ref.watch(themeModeProvider);


    final darkTheme = ref.watch(darkThemeProvider);
    final lightTheme = ref.watch(lightThemeProvider);

    return MaterialApp(
      title: 'Date Sheild',
      debugShowCheckedModeBanner: false,


      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeMode,


      home: const LandingPage(),


      routes: {
        '/home': (context) => const HomePage(),
        '/game' : (context)  => const GamesScreen(),
      },
    );
  }
}