import 'package:jobpulse/base/di/get_it.dart';
import 'package:jobpulse/base/presentation/widgets/buttons/dialog_button.dart';
import 'package:jobpulse/base/presentation/widgets/loader.dart';
import 'package:jobpulse/base/presentation/widgets/snackbar.dart';
import 'package:jobpulse/base/providers/user_provider.dart';
import 'package:jobpulse/job/domain/models/job.dart';
import 'package:jobpulse/job/presentation/view_models/job_view_model.dart';
import 'package:jobpulse/job/presentation/widgets/applicant_card.dart';
import 'package:jobpulse/user/domain/models/user.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class JobDetailScreen extends StatefulWidget {
  const JobDetailScreen({super.key, required this.job});
  final JobModel job;

  @override
  State<JobDetailScreen> createState() => _JobDetailScreenState();
}

class _JobDetailScreenState extends State<JobDetailScreen> {
  final _jobViewModel = getIt<JobViewModel>();
  UserModel? _loggedInUser;
  List<UserModel?> _applicants = [];
  bool _isLoading = false;

  void initialize() async {
    setState(() {_isLoading = true;});
    List<UserModel?>? applicants = await _jobViewModel.getJobApplicants(widget.job.id);
    setState(() {
      _isLoading = false;
      _applicants = applicants ?? [];
    });
  }

  void applyJob(context) async {
    setState(() {_isLoading = true;});

    String response = await _jobViewModel.applyJob(
        jobId: widget.job.id,
        userId: _loggedInUser!.uid
    );

    if(response == "success") {
      showSnackBar(context, "Your application has been submitted", Colors.green);
    } else if (response == "already-applied") {
      showSnackBar(context, "You have already applied for this job", Colors.redAccent);
    } else {
      showSnackBar(context, "Something went wrong", Colors.red);
    }
    setState(() {_isLoading = false;});
  }

  @override
  void initState() {
    super.initState();
    _loggedInUser = Provider.of<UserProvider>(context, listen: false).user;
    initialize();
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          backgroundColor: theme.colorScheme.primary,
          title: Text(
            "Job Detail",
            style: theme.textTheme.headlineMedium?.copyWith(
              color: theme.colorScheme.onPrimary
            ),
          ),
        ),
        body: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.width * 0.07,),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                widget.job.userProfilePic != null && widget.job.userProfilePic != "" ? CircleAvatar(
                                  radius: 20,
                                  backgroundImage: NetworkImage(widget.job.userProfilePic!),
                                ) : const CircleAvatar(
                                  radius: 20,
                                  backgroundImage: AssetImage("assets/avatar.jpg"),
                                ),
                                const SizedBox(width: 10,),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.job.companyName,
                                      style: theme.textTheme.bodyMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: theme.colorScheme.primary
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      timeago.format(DateFormat('yyyy-MM-dd HH:mm:ss.SSS').parse(widget.job.datePosted)),
                                      style: theme.textTheme.bodyMedium?.copyWith(
                                        color: theme.colorScheme.onBackground.withOpacity(0.5)
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ]
                                )
                              ],
                            ),
                            !_loggedInUser!.isCompany & _isLoading ? const Padding(
                              padding: EdgeInsets.only(right: 32.0),
                              child: Loader (size: 20,),
                            ) :
                            !_loggedInUser!.isCompany ? InkWell(
                                onTap: () {applyJob(context);},
                                child: const DialogButton(
                                  btnText: "Apply",
                                  width: 75,
                                )
                            ) : Container()
                          ],
                        ),
                        const SizedBox(height: 8,),
                        Text(
                          widget.job.jobTitle,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.visible,
                        ),
                        Text(
                          widget.job.description,
                          style: theme.textTheme.bodyMedium,
                          overflow: TextOverflow.visible,
                        ),
                        const SizedBox(height: 5,),
                        Text(
                          "Skills Required: ${widget.job.skillsRequired}",
                          style: theme.textTheme.bodyMedium,
                          overflow: TextOverflow.visible,
                        ),
                        Text(
                          "Type: ${widget.job.type}",
                          style: theme.textTheme.bodyMedium,
                          overflow: TextOverflow.visible,
                        ),
                        Text(
                          "Experience Level: ${widget.job.experienceLevel}",
                          style: theme.textTheme.bodyMedium,
                          overflow: TextOverflow.visible,
                        ),
                        Text(
                          "Location: ${widget.job.location}",
                          style: theme.textTheme.bodyMedium,
                          overflow: TextOverflow.visible,
                        ),
                        Text(
                          widget.job.opened ? "Opened: Yes" : "Opened: No",
                          style: theme.textTheme.bodyMedium,
                          overflow: TextOverflow.visible,
                        ),
                      _loggedInUser!.uid == widget.job.userId ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 16,),
                          Text(
                            "Applicants",
                            style: theme.textTheme.headlineLarge,
                            overflow: TextOverflow.visible,
                          ),
                          const SizedBox(height: 8,),
                          ..._applicants.map((applicant) => ApplicantCard(applicant: applicant!))
                        ],
                      ) : Container(),
                      ],
                    )
                  ],
                )
            )
        )
    );
  }
}
