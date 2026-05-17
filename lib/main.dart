import 'package:flutter/material.dart';
import 'data/date_ideas.dart';
import 'models/date_idea.dart';
import 'screens/intro_screen.dart';
import 'screens/comparison_screen.dart';
import 'screens/result_screen.dart';

void main() {
  runApp(const DatePickerApp());
}

/// The main app widget with Material 3 theming.
class DatePickerApp extends StatelessWidget {
  const DatePickerApp({super.key});

  @override
  Widget build(BuildContext context) {
    const seedColor = Color(0xFFC75C6E);
    final baseTextTheme = Typography.material2021().black;
    final darkTextTheme = Typography.material2021().white;

    return MaterialApp(
      title: 'Our Perfect Date',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: seedColor,
          brightness: Brightness.light,
          primary: const Color(0xFFC55A72),
          secondary: const Color(0xFFE8A86D),
          surface: const Color(0xFFFFF8F5),
        ),
        scaffoldBackgroundColor: const Color(0xFFFFF8F5),
        textTheme: baseTextTheme.copyWith(
          displayLarge: baseTextTheme.displayLarge?.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: -1.8,
          ),
          displayMedium: baseTextTheme.displayMedium?.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: -1.2,
          ),
          displaySmall: baseTextTheme.displaySmall?.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: -0.9,
          ),
          headlineMedium: baseTextTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: -0.8,
          ),
          headlineSmall: baseTextTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: -0.4,
          ),
          titleLarge: baseTextTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: -0.2,
          ),
          bodyLarge: baseTextTheme.bodyLarge?.copyWith(height: 1.5),
          bodyMedium: baseTextTheme.bodyMedium?.copyWith(height: 1.45),
        ),
        cardTheme: CardThemeData(
          color: Colors.white.withValues(alpha: 0.9),
          elevation: 0,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFFB84261),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(22),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.1,
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(22),
            ),
            side: BorderSide(
              color: seedColor.withValues(alpha: 0.22),
            ),
            textStyle: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: seedColor,
          brightness: Brightness.dark,
          primary: const Color(0xFFF296A5),
          secondary: const Color(0xFFF1BE8D),
          surface: const Color(0xFF1F1620),
        ),
        scaffoldBackgroundColor: const Color(0xFF1B141B),
        textTheme: darkTextTheme.copyWith(
          displayLarge: darkTextTheme.displayLarge?.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: -1.8,
          ),
          displayMedium: darkTextTheme.displayMedium?.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: -1.2,
          ),
          displaySmall: darkTextTheme.displaySmall?.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: -0.9,
          ),
          headlineMedium: darkTextTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: -0.8,
          ),
          headlineSmall: darkTextTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: -0.4,
          ),
          titleLarge: darkTextTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: -0.2,
          ),
          bodyLarge: darkTextTheme.bodyLarge?.copyWith(height: 1.5),
          bodyMedium: darkTextTheme.bodyMedium?.copyWith(height: 1.45),
        ),
        cardTheme: CardThemeData(
          color: Colors.white.withValues(alpha: 0.07),
          elevation: 0,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
      themeMode: ThemeMode.system,
      home: const DatePickerHome(),
    );
  }
}

/// The app state that determines which screen to show.
enum AppScreen { intro, comparison, result }

/// Set to true to randomize idea order, false to show in sequence by ID.
const bool shuffleIdeas = false;

/// Home widget that manages navigation between screens.
class DatePickerHome extends StatefulWidget {
  const DatePickerHome({super.key});

  @override
  State<DatePickerHome> createState() => _DatePickerHomeState();
}

class _DatePickerHomeState extends State<DatePickerHome> {
  AppScreen _currentScreen = AppScreen.intro;
  DateIdea? _winner;
  List<DateIdea> _loadedIdeas = [];
  List<DateIdea> _shuffledIdeas = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadIdeas();
  }

  Future<void> _loadIdeas() async {
    final ideas = await loadDateIdeas();
    setState(() {
      _loadedIdeas = ideas;
      _loading = false;
      _shuffleIdeas();
    });
  }

  void _shuffleIdeas() {
    if (shuffleIdeas) {
      _shuffledIdeas = List.from(_loadedIdeas)..shuffle();
    } else {
      _shuffledIdeas = List.from(_loadedIdeas)
        ..sort((a, b) => a.id.compareTo(b.id));
    }
  }

  void _startComparison() {
    setState(() {
      _shuffleIdeas();
      _currentScreen = AppScreen.comparison;
    });
  }

  void _showResult(DateIdea winner) {
    setState(() {
      _winner = winner;
      _currentScreen = AppScreen.result;
    });
  }

  void _restart() {
    setState(() {
      _winner = null;
      _currentScreen = AppScreen.intro;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (child, animation) {
        return FadeTransition(opacity: animation, child: child);
      },
      child: _buildCurrentScreen(),
    );
  }

  Widget _buildCurrentScreen() {
    switch (_currentScreen) {
      case AppScreen.intro:
        return IntroScreen(
          key: const ValueKey('intro'),
          onStart: _startComparison,
        );
      case AppScreen.comparison:
        return ComparisonScreen(
          key: const ValueKey('comparison'),
          dateIdeas: _shuffledIdeas,
          onComplete: _showResult,
        );
      case AppScreen.result:
        return ResultScreen(
          key: const ValueKey('result'),
          winner: _winner!,
          onRestart: _restart,
        );
    }
  }
}
