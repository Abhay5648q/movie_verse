import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'data/models/show_model.dart';
import 'providers/favorites_provider.dart';
import 'providers/show_provider.dart';
import 'providers/theme_provider.dart';
import 'screens/home/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(ShowAdapter());
  await Hive.openBox<Show>('favorites');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ShowProvider()),
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Smollan Movie Verse',

            theme: ThemeData(
              brightness: Brightness.light,
              colorSchemeSeed: Colors.blue,
              useMaterial3: true,
            ),

            darkTheme: ThemeData(
              brightness: Brightness.dark,
              colorSchemeSeed: Colors.blue,
              useMaterial3: true,
            ),

            themeMode: themeProvider.isDark
                ? ThemeMode.dark
                : ThemeMode.light,

            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}