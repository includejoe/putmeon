import 'package:jobpulse/base/di/get_it.dart';
import 'package:jobpulse/base/presentation/theme/theme_provider.dart';
import 'package:jobpulse/base/presentation/widgets/buttons/floating_action_button.dart';
import 'package:jobpulse/base/presentation/widgets/empty_list_placeholder.dart';
import 'package:jobpulse/base/presentation/widgets/loader.dart';
import 'package:jobpulse/base/presentation/widgets/page_refresher.dart';
import 'package:jobpulse/base/providers/user_provider.dart';
import 'package:jobpulse/job/domain/models/job.dart';
import 'package:jobpulse/job/presentation/view_models/job_view_model.dart';
import 'package:jobpulse/job/presentation/widgets/job_card.dart';
import 'package:jobpulse/job/presentation/widgets/job_form.dart';
import 'package:jobpulse/user/domain/models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class JobsScreen extends StatefulWidget {
  const JobsScreen({super.key});

  @override
  State<JobsScreen> createState() => _JobsScreenState();
}

class _JobsScreenState extends State<JobsScreen> {
  final _viewModel = getIt<JobViewModel>();
  final _refreshController = RefreshController(initialRefresh: false);
  bool _isLoading = false;
  bool _isError = false;
  UserModel? _user;
  List<JobModel?> _jobs = [];

  void getJobs() async {
    List<JobModel?>? jobs;
    setState(() {
      _isLoading = true;
      _isError = false;
    });

    jobs =  await _viewModel.getAllJobs(_user!);

    if(jobs != null) {
      setState(() {
        _jobs = jobs!;
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
        _isError = true;
      });
    }
  }

  @override
  void initState() {
    _user = Provider.of<UserProvider>(context, listen: false).user;
    getJobs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final jobCards = _jobs.map((job) => JobCard(
      job: job!,
      isCompany: _user!.isCompany,
      userId: _user!.uid,
    )).toList();

    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: theme.colorScheme.primary,
          title: Text(
            "Job Pulse",
            style: theme.textTheme.headlineMedium?.copyWith(
                color: theme.colorScheme.onPrimary
            ),
          ),
        ),
        body: _isLoading ? const Center(child: Loader(size: 30),) :
        _isError ? PageRefresher(onRefresh: getJobs) :
        SmartRefresher(
          controller: _refreshController,
          onRefresh: getJobs,
          header: MaterialClassicHeader(
            color: theme.colorScheme.primary,
            backgroundColor: theme.colorScheme.background,
          ),
          child: _jobs.isNotEmpty ? ListView.builder(
              scrollDirection: Axis.vertical,
              padding: const EdgeInsets.all(8),
              itemCount: jobCards.length,
              itemBuilder: (context, index) {
                return jobCards[index];
              }
          ) : const EmptyListPlaceholder(
            icon: CupertinoIcons.bag_fill,
            message: "No jobs available at this time.",
          ),
        ),
        floatingActionButton: _user!.isCompany ? FloatActionButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) => JobForm(getJobs: getJobs,)
              );
            },
            icon: CupertinoIcons.add
        ) : null
    );
  }
}
