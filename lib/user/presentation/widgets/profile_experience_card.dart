import 'package:jobpulse/user/domain/models/experience.dart';
import 'package:flutter/material.dart';

class ProfileExperienceCard extends StatelessWidget {
  const ProfileExperienceCard({super.key, required this.experience});
  final ExperienceModel experience;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              experience.jobTitle,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 18
              ),
              overflow: TextOverflow.visible,
            ),
            Text(
              experience.company,
              style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold
              ),
              overflow: TextOverflow.visible,
            ),
            Text(
              experience.description,
              style: theme.textTheme.bodyMedium,
              overflow: TextOverflow.visible,
            ),
            const SizedBox(height: 5),
            Text(
              "${experience.startDate} to ${experience.endDate}",
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold
              ),
              overflow: TextOverflow.visible,
            ),
          ],
        ),
        const SizedBox(height: 8,)
      ],
    );
  }
}
