import 'package:jobpulse/base/di/get_it.dart';
import 'package:jobpulse/base/presentation/widgets/dialogs/confirmation_dialog.dart';
import 'package:jobpulse/base/presentation/widgets/list_item.dart';
import 'package:jobpulse/base/providers/user_provider.dart';
import 'package:jobpulse/user/domain/models/user.dart';
import 'package:jobpulse/user/presentation/screens/edit_profile_screen.dart';
import 'package:jobpulse/user/presentation/screens/employment_history_screen.dart';
import 'package:jobpulse/user/presentation/screens/login_screen.dart';
import 'package:jobpulse/user/presentation/view_models/user_view_model.dart';
import 'package:jobpulse/user/presentation/widgets/theme_switch.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _userViewModel = getIt<UserViewModel>();
  final _userProvider = getIt<UserProvider>();
  UserModel? _user;

  @override
  void initState() {
    super.initState();
    _userProvider.init();
    _user = _userProvider.user;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final items =[
      ListItem(
        icon: CupertinoIcons.person_fill,
        text: "Edit Profile",
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const EditProfileScreen()
              )
          );
        },
      ),
      !_user!.isCompany ? ListItem(
        icon: CupertinoIcons.doc_append,
        text: "Employment History",
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const EmploymentHistoryScreen()
              )
          );
        },
      ) : Container(),
      const ListItem(
        icon: CupertinoIcons.sun_max_fill,
        text: "Dark Theme",
        suffixWidget: ThemeSwitch(),
      ),
      ListItem(
        icon: CupertinoIcons.power,
        text: "Sign Out",
        onTap: () {
          confirmationDialog(
            context: context,
            title: "Are you sure you want to sign out?",
            yesAction: () {
              _userViewModel.signOut();
              _userProvider.clearUser();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginScreen()
                )
              );
            }
          );
        },
      )
    ];

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: theme.colorScheme.primary,
        title: Text(
          "Settings",
          style: theme.textTheme.headlineMedium?.copyWith(
              color: theme.colorScheme.onPrimary
          ),
        ),
      ),
      body: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: items.length,
        itemBuilder: (context, index) {
          return items[index];
        }
      )
    );
  }
}
