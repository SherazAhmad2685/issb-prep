import 'package:flutter/material.dart';
import '../screens/home/home_screen.dart';
import '../screens/papers/issb_papers_screen.dart';
import '../screens/psych/psych_screen.dart';
import '../screens/gto/gto_screen.dart';
import '../screens/progress/progress_screen.dart';
import '../core/theme/app_theme.dart';


class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  static const _pages = [
    HomeScreen(),
    IssbPapersScreen(),
    PsychScreen(),
    GtoScreen(),
    ProgressScreen(),
  ];

  static const _navItems = [
    BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
    BottomNavigationBarItem(icon: Icon(Icons.assignment_rounded), label: 'Papers'),
    BottomNavigationBarItem(icon: Icon(Icons.psychology_rounded), label: 'Psych'),
    BottomNavigationBarItem(icon: Icon(Icons.military_tech_rounded), label: 'GTO'),
    BottomNavigationBarItem(icon: Icon(Icons.bar_chart_rounded), label: 'Progress'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: AppTheme.border, width: 1),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (i) => setState(() => _currentIndex = i),
          items: _navItems,
        ),
      ),
    );
  }
}
