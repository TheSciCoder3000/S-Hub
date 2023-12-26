import 'package:flutter/material.dart';
import 'package:s_hub/screens/dashboard/ical_viewer.dart';
import 'package:s_hub/screens/dashboard/index.dart';
import 'package:s_hub/screens/settings/settings.dart';

class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  int selectedIndex = 0;
  final PageController _controller = PageController();
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const Dashboard(),
      const ICalViewer(),
      Container(),
      const AppSettigs()
    ];
  }

  void navigateTo(int index) {
    setState(() {
      selectedIndex = index;
      _controller.animateToPage(index, duration: const Duration(milliseconds: 100), curve: Curves.linear);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _controller,
        onPageChanged: (value) => setState(() {
          selectedIndex = value;
        }),
        children: _pages
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: const FloatingActionButton(
        onPressed: null,
        backgroundColor: Color.fromARGB(255, 0, 205, 109),
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 75.0,
        notchMargin: 7.0,
        shadowColor: const Color.fromARGB(255, 255, 255, 255),
        shape: const CircularNotchedRectangle(),
        color: const Color.fromARGB(255, 28, 49, 38),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              NavButton(
                selected: selectedIndex == 0,
                onPressed: () => navigateTo(0), 
                icon: const Icon(Icons.dashboard, size: 30.0,)
              ),
              NavButton(
                selected: selectedIndex == 1,
                onPressed: () => navigateTo(1), 
                icon: const Icon(Icons.calendar_month, size: 30.0,)
              ),
              const SizedBox(width: 30.0),
              NavButton(
                selected: selectedIndex == 2,
                onPressed: () => navigateTo(2), 
                icon: const Icon(Icons.info, size: 30.0,)
              ),
              NavButton(
                selected: selectedIndex == 3,
                onPressed: () => navigateTo(3), 
                icon: const Icon(Icons.settings, size: 30.0,)
              ),
            ],
          ),
        ),
      )
    );
  }
}

class NavButton extends StatefulWidget {
  const NavButton({super.key, required this.icon, required this.onPressed, required this.selected});
  final Widget icon;
  final VoidCallback onPressed;
  final bool selected;

  @override
  State<NavButton> createState() => _NavButtonState();
}

class _NavButtonState extends State<NavButton> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      color: widget.selected ? const Color.fromARGB(255, 202, 202, 202) : const Color.fromARGB(255, 108, 108, 108),
      onPressed: widget.onPressed, 
      icon: widget.icon
    );
  }
}