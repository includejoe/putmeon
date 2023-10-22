import 'package:jobpulse/user/domain/models/user.dart';
import 'package:jobpulse/user/presentation/screens/profile_screen.dart';
import 'package:flutter/material.dart';


class ApplicantCard extends StatelessWidget {
  const ApplicantCard({super.key, required this.applicant});
  final UserModel applicant;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: theme.colorScheme.background,
            border: Border(
              bottom: BorderSide(
                width: 1,
                color: theme.colorScheme.background
              )
            ),
          ),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileScreen(
                    user: applicant,
                    myProfile: false,
                  )
                )
              );
            },
            child: Row(
              children: [
                applicant.profilePic != null && applicant.profilePic != "" ? CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(applicant.profilePic!),
                  backgroundColor: theme.colorScheme.primary,
                ) : CircleAvatar(
                  radius: 20,
                  backgroundImage: const AssetImage("assets/avatar.jpg"),
                  backgroundColor: theme.colorScheme.primary,
                ),
                const SizedBox(width: 10,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      applicant.name,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.visible,
                    ),
                    Text(
                      applicant.headline,
                      style: theme.textTheme.bodyMedium,
                      overflow: TextOverflow.visible,
                    ),
                  ]
                )
              ],
            ),
          ),
        ),
        const SizedBox(height: 18,)
      ],
    );
  }
}
