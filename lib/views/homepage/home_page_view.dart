import 'package:flutter/material.dart';
import 'package:myapp/utils/palletes.dart';
import 'package:myapp/views/homepage/contact_list_view.dart';
import 'package:myapp/views/homepage/profile_view.dart';

class HomePageView extends StatefulWidget {
  final String id;
  const HomePageView({super.key, required this.id});

  @override
  State<StatefulWidget> createState() {
    return HomePageViewState();
  }
}

class HomePageViewState extends State<HomePageView> {
  int _selectedIndex = 0;
  List<Widget> _pages = [];

  @override
  void initState() {
    _pages = [
      ContactListView(id: widget.id),
      ProfileView(id: widget.id),
    ];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (value) {
          setState(() {
            _selectedIndex = value;
          });
        },
        backgroundColor: Palette.white,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: Palette.blue,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.window),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
