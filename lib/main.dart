import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:randomiser/homeScreen.dart';


class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;

  void toggleTheme(bool isDark) {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}


void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.purple,
          brightness: Brightness.light,
        ).copyWith(
          background: Colors.purple[100],
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontSize:  72.0, fontWeight: FontWeight.bold),
          displayMedium: TextStyle(fontSize:  36.0, fontStyle: FontStyle.italic),
          bodyLarge: TextStyle(fontSize:  21.0, fontWeight: FontWeight.bold, fontFamily: 'Roboto'),
        ),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.grey,
          brightness: Brightness.dark,
        ).copyWith(
          background: Colors.grey[850],
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontSize:  72.0, fontWeight: FontWeight.bold),
          displayMedium: TextStyle(fontSize:  36.0, fontStyle: FontStyle.italic),
          bodyLarge: TextStyle(fontSize:  21.0, fontWeight: FontWeight.bold, fontFamily: 'Roboto'),
        ),
      ),
      themeMode: context.watch<ThemeProvider>().themeMode, // Use system theme (light/dark)
      home: const SplashScreen(),
    );
  }
}


class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1500)).then((_) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.casino_rounded,
              size: 150,
              color: Theme.of(context).hintColor,
            ),
            const SizedBox(height: 20),
            Text(
              'RNGeez',
              style: Theme.of(context).textTheme.displayLarge,
            ),
          ],
        ),
      ),
    );
  }
}


