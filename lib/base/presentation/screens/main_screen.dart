import 'dart:io';
import 'package:jobpulse/base/presentation/widgets/loader.dart';
import 'package:jobpulse/base/providers/user_provider.dart';
import 'package:jobpulse/job/presentation/screens/jobs_screen.dart';
import 'package:jobpulse/user/presentation/screens/profile_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentScreen = 0;
  final PageController _pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Consumer<UserProvider>(
      builder: (context, userProvider, child){
        final user = userProvider.user;
        return Scaffold(
          body: user == null ? const Center(child: Loader(size: 24)) : PageView(
            controller: _pageController,
            physics: const BouncingScrollPhysics(),
            onPageChanged: (int index) {setState(() { _currentScreen = index;});},
            children:  <Widget> [
              JobsScreen(user: user),
              ProfileScreen(user: user, myProfile: true,),
            ]
          ),
          bottomNavigationBar: SizedBox(
            height: Platform.isIOS ? 90 : 60,
            child: BottomNavigationBar(
              currentIndex: _currentScreen,
              selectedItemColor: theme.colorScheme.primary,
              unselectedItemColor: Colors.white,
              backgroundColor: Colors.black,
              type: BottomNavigationBarType.fixed,
              showSelectedLabels: true,
              showUnselectedLabels: true,
              onTap: (int index) {
                _pageController.jumpToPage(index);
              },
              items:  <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(_currentScreen == 0 ?
                  CupertinoIcons.bag_fill :
                  CupertinoIcons.bag
                  ),
                  label: 'Jobs'
                ),
                BottomNavigationBarItem(
                  icon: Icon(_currentScreen == 1 ?
                  CupertinoIcons.person_fill :
                  CupertinoIcons.person
                  ),
                  label: 'Profile'
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}
