import 'package:jobpulse/base/di/get_it.dart';
import 'package:jobpulse/base/presentation/widgets/buttons/round_button.dart';
import 'package:jobpulse/base/presentation/widgets/dialogs/confirmation_dialog.dart';
import 'package:jobpulse/base/presentation/widgets/snackbar.dart';
import 'package:jobpulse/user/domain/models/experience.dart';
import 'package:jobpulse/user/presentation/view_models/experience_view_model.dart';
import 'package:jobpulse/user/presentation/widgets/experience_form.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ExperienceCard extends StatelessWidget {
  ExperienceCard({super.key, required this.experience, required this.getUserExperiences});
  final ExperienceModel experience;
  final void Function() getUserExperiences;
  final _viewModel = getIt<ExperienceViewModel>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: 150,
          decoration: BoxDecoration(
            color: theme.colorScheme.background,
            border: Border(
              bottom: BorderSide(
                width: 1,
                color: theme.colorScheme.background
              )
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),  // Shadow color
                spreadRadius: 1,  // Spread radius
                blurRadius: 5,    // Blur radius
                offset: const Offset(0, 3),  // Offset
              ),
            ],
          ),
          child: InkWell(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    experience.jobTitle,
                    style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 22
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8,),
                  Text(
                    experience.company,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(width: 8,),
                  Text(
                    experience.description,
                    style: theme.textTheme.bodyMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8,),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${experience.startDate} to ${experience.endDate}",
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Row(
                        children: [
                          RoundButton(
                            icon: CupertinoIcons.pen,
                            backgroundColor: Colors.green,
                            onClick: (){
                              showDialog(
                                context: context,
                                builder: (BuildContext context) => ExperienceForm(
                                  experience: experience,
                                  getUserExperiences: getUserExperiences
                                )
                              );
                            },
                          ),
                          const SizedBox(width: 5,),
                          RoundButton(
                            icon: CupertinoIcons.trash,
                            backgroundColor: theme.colorScheme.error,
                            onClick: (){
                              confirmationDialog(
                                context: context,
                                title: "Are you sure you delete this?",
                                yesAction: () {
                                  _viewModel.deleteExperience(id: experience.id);
                                  showSnackBar(context, "Experience deleted successfully", Colors.green);
                                  getUserExperiences();
                                }
                              );
                            },
                          )
                        ],
                      )
                    ],
                  ),
                ],
              ),
            )
          ),
        ),
        const SizedBox(height: 6,)
      ],
    );
  }
}
