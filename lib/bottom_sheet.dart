import 'package:flutter/material.dart';

import 'package:halal_guide/camera_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 1;
  final List<Widget> _pages = <Widget>[];
  @override
  void initState() {
    _pages.add(const CategoryScreen());
    _pages.add(const MainScreen());
    _pages.add(const SettingScreen());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        clipBehavior: Clip.antiAlias,
        child: SizedBox(
          height: kBottomNavigationBarHeight,
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(
                  color: Colors.grey,
                  width: 0.5,
                ),
              ),
            ),
            child: BottomNavigationBar(
                currentIndex: _currentIndex,
                backgroundColor: Colors.blue,
                selectedItemColor: Colors.white,
                onTap: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                items: const [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.category), label: 'О продуктах'),
                  BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.settings_outlined), label: 'Настройки')
                ]),
          ),
        ),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FloatingActionButton(
          backgroundColor: _currentIndex == 1 ? Colors.blue : Colors.blueGrey,
          child: const Icon(Icons.camera),
          onPressed: () => setState(() {
            _currentIndex = 1;
          }),
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Center(child: Text('Home')),
    );
  }
}

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Center(child: Text('Продукты')),
    );
  }
}

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Center(child: Text('Настройки')),
    );
  }
}
