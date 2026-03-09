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
    return MaterialApp(
      title: 'Our Perfect Date',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        // Warm, romantic color scheme
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFE57373), // Soft rose/coral
          brightness: Brightness.light,
        ),
        fontFamily: 'Roboto',
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFE57373),
          brightness: Brightness.dark,
        ),
        fontFamily: 'Roboto',
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
