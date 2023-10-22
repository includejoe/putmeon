import 'package:jobpulse/base/di/get_it.dart';
import 'package:jobpulse/base/presentation/widgets/buttons/dialog_button.dart';
import 'package:jobpulse/base/presentation/widgets/inputs/select_input.dart';
import 'package:jobpulse/base/presentation/widgets/inputs/text_input.dart';
import 'package:jobpulse/base/presentation/widgets/loader.dart';
import 'package:jobpulse/base/presentation/widgets/snackbar.dart';
import 'package:jobpulse/base/providers/user_provider.dart';
import 'package:jobpulse/base/utils/input_validators/text.dart';
import 'package:jobpulse/job/domain/models/job.dart';
import 'package:jobpulse/job/presentation/view_models/job_view_model.dart';
import 'package:jobpulse/user/domain/models/user.dart';
import 'package:flutter/material.dart';

class JobForm extends StatefulWidget {
  const JobForm({super.key, required this.getJobs, this.job});

  final void Function() getJobs;
  final JobModel? job;


  @override
  State<JobForm> createState() => _JobFormState();
}

class _JobFormState extends State<JobForm> {
  final _viewModel = getIt<JobViewModel>();
  final _userProvider = getIt<UserProvider>();
  bool _isLoading = false;
  UserModel? _user;

  // controllers
  final _jobTitleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _skillsRequiredController = TextEditingController();
  final _locationController = TextEditingController();
  final _experienceLevelController = TextEditingController();
  final _typeController = TextEditingController();

  // focus nodes
  final _descriptionFocusNode = FocusNode();
  final _skillsRequiredFocusNode = FocusNode();
  final _locationFocusNode = FocusNode();
  final _experienceLevelFocusNode = FocusNode();
  final _typeFocusNode = FocusNode();

  // errors
  String? _jobTitleError;
  String? _descriptionError;
  String? _skillsRequiredError;
  String? _locationError;
  String? _experienceLevelError;
  String? _typeError;

  void addJob(context) async {
    setState(() { _isLoading = true;});
    bool successful = await _viewModel.addJob(
      id: widget.job?.id,
      companyName: _user!.name,
      jobTitle: _jobTitleController.text,
      description: _descriptionController.text,
      skillsRequired: _skillsRequiredController.text,
      location: _locationController.text,
      type: _typeController.text,
      experienceLevel: _experienceLevelController.text,
      opened: true,
      userProfilePic: _user!.profilePic
    );

    if(successful) {
      showSnackBar(context, "Job posted successfully", Colors.green);
      widget.getJobs();
    } else {
      showSnackBar(context, "Something went wrong", Colors.red);
    }

    Navigator.pop(context);
    setState(() { _isLoading = false;});
  }

  @override
  void dispose() {
    _jobTitleController.dispose();
    _skillsRequiredController.dispose();
    _experienceLevelController.dispose();
    _typeController.dispose();
    _descriptionController.dispose();
    _descriptionFocusNode.dispose();
    _skillsRequiredFocusNode.dispose();
    _experienceLevelFocusNode.dispose();
    _typeFocusNode.dispose();
    _descriptionFocusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _userProvider.init();
    _user = _userProvider.user;
    if(widget.job != null) {
      _jobTitleController.text = widget.job!.jobTitle;
      _descriptionController.text = widget.job!.description;
      _skillsRequiredController.text = widget.job!.skillsRequired;
      _experienceLevelController.text = widget.job!.experienceLevel;
      _typeController.text = widget.job!.type;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
  final theme = Theme.of(context);
  final jobTitleValidator = TextValidator(context);
  final descriptionValidator = TextValidator(context);
  final skillsRequiredValidator = TextValidator(context);
  final experienceLevelValidator = TextValidator(context);
  final typeValidator = TextValidator(context);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      backgroundColor: theme.colorScheme.background,
      insetPadding: const EdgeInsets.all(25),
      child: _isLoading ? const Center(child: Loader(size: 24)) :
      SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Post Job",
                style: theme.textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
                textAlign: TextAlign.start,
              ),
              const SizedBox(height: 25,),
              TextInput(
                controller: _jobTitleController,
                textInputType: TextInputType.text,
                inputAction: TextInputAction.next,
                enabled: true,
                label: "Job Title",
                placeholder: "ex. Software Engineer",
                error: _jobTitleError,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_descriptionFocusNode);
                },
              ),
              const SizedBox(height: 15,),
              TextInput(
                controller: _descriptionController,
                textInputType: TextInputType.text,
                inputAction: TextInputAction.next,
                enabled: true,
                label: "Description",
                error: _descriptionError,
                focusNode: _descriptionFocusNode,
                maxLines: 5,
                height: 100,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_skillsRequiredFocusNode);
                },
              ),
              const SizedBox(height: 15,),
              TextInput(
                controller: _skillsRequiredController,
                textInputType: TextInputType.text,
                inputAction: TextInputAction.next,
                enabled: true,
                label: "Skills Required",
                placeholder: "ex. Java, Python",
                error: _skillsRequiredError,
                focusNode: _skillsRequiredFocusNode,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_locationFocusNode);
                },
              ),
              const SizedBox(height: 15,),
              TextInput(
                controller: _locationController,
                textInputType: TextInputType.text,
                inputAction: TextInputAction.next,
                enabled: true,
                label: "Location",
                placeholder: "ex. Accra, Ghana",
                error: _locationError,
                focusNode: _locationFocusNode,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_typeFocusNode);
                },
              ),
              const SizedBox(height: 15,),
              SelectInput(
                controller: _typeController,
                focusNode: _typeFocusNode,
                inputAction: TextInputAction.next,
                label: "Type",
                placeholder: "ex. On Site, Remote, Hybrid",
                dialogTitle: "Select Job Type",
                error: _typeError,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_experienceLevelFocusNode);
                },
                options: const ["On Site", "Remote", "Hybrid"],
              ),
              const SizedBox(height: 15,),
              SelectInput(
                controller: _experienceLevelController,
                focusNode: _experienceLevelFocusNode,
                inputAction: TextInputAction.next,
                label: "Experience Level",
                placeholder: "ex. Junior, Mid-Level, Senior",
                dialogTitle: "Select Experience Level",
                error: _experienceLevelError,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).unfocus();
                },
                options: const ["Junior", "Mid-Level", "Senior"],
              ),
              const SizedBox(height: 15,),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                      onTap: () {Navigator.pop(context);},
                      child: DialogButton(
                        btnText: "Cancel",
                        height: 40,
                        width: 70,
                        background: Colors.transparent,
                        color: theme.colorScheme.onBackground,
                      )
                  ),
                  const SizedBox(width: 10,),
                  InkWell(
                    onTap: () {
                      setState(() {
                        _jobTitleError = jobTitleValidator(_jobTitleController.text);
                        _descriptionError = descriptionValidator(_descriptionController.text);
                        _skillsRequiredError = skillsRequiredValidator(_skillsRequiredController.text);
                        _typeError = typeValidator(_typeController.text);
                        _experienceLevelError = experienceLevelValidator(_experienceLevelController.text);
                      });

                      final errors = [
                        _jobTitleError,
                        _descriptionError,
                        _skillsRequiredError,
                        _typeError,
                        _experienceLevelError
                      ];

                      if(errors.every((error) => error == null)) {
                        FocusScope.of(context).unfocus();
                        addJob(context);
                      }
                    },
                    child: const DialogButton(
                      btnText: "Save",
                      height: 40,
                      width: 70
                    )
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
