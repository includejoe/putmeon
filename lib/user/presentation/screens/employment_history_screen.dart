import 'package:jobpulse/base/di/get_it.dart';
import 'package:jobpulse/base/presentation/widgets/buttons/floating_action_button.dart';
import 'package:jobpulse/base/presentation/widgets/empty_list_placeholder.dart';
import 'package:jobpulse/base/presentation/widgets/loader.dart';
import 'package:jobpulse/base/presentation/widgets/page_refresher.dart';
import 'package:jobpulse/user/domain/models/experience.dart';
import 'package:jobpulse/user/presentation/view_models/experience_view_model.dart';
import 'package:jobpulse/user/presentation/widgets/experience_card.dart';
import 'package:jobpulse/user/presentation/widgets/experience_form.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class EmploymentHistoryScreen extends StatefulWidget {
  const EmploymentHistoryScreen({super.key});

  @override
  State<EmploymentHistoryScreen> createState() => _EmploymentHistoryScreenState();
}

class _EmploymentHistoryScreenState extends State<EmploymentHistoryScreen> {
  final _viewModel = getIt<ExperienceViewModel>();
  final _refreshController = RefreshController(initialRefresh: false);
  bool _isLoading = false;
  bool _isError = false;
  List<ExperienceModel?> _experiences = [];

  void getExperiences() async {
    List<ExperienceModel?>? experiences;
    setState(() {
      _isLoading = true;
      _isError = false;
    });

    experiences =  await _viewModel.getUserExperiences(null); // fetch logged in user experience if userId is null

    if(experiences != null) {
      setState(() {
        _experiences = experiences!;
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
    super.initState();
    getExperiences();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final experienceCards = _experiences.map((experience) => ExperienceCard(
      experience: experience!,
      getUserExperiences: getExperiences
    )).toList();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: theme.colorScheme.primary,
        title: Text(
          "Employment History",
          style: theme.textTheme.headlineMedium?.copyWith(
              color: theme.colorScheme.onPrimary
          ),
        ),
      ),
      body: _isLoading ? const Center(child: Loader(size: 30),) :
        _isError ? PageRefresher(onRefresh: getExperiences) :
        SmartRefresher(
          controller: _refreshController,
          onRefresh: getExperiences,
          header: MaterialClassicHeader(
            color: theme.colorScheme.primary,
            backgroundColor: theme.colorScheme.background,
          ),
          child: _experiences.isNotEmpty ? ListView.builder(
            scrollDirection: Axis.vertical,
            padding: const EdgeInsets.all(8),
            itemCount: experienceCards.length,
            itemBuilder: (context, index) {
              return experienceCards[index];
            }
          ) : const EmptyListPlaceholder(
            icon: CupertinoIcons.bag_fill,
            message: "You haven't added any experiences yet",
          ),
      ),
      floatingActionButton: FloatActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) => ExperienceForm(getUserExperiences: getExperiences)
          );
        },
        icon: CupertinoIcons.add
      )
    );
  }
}
