import 'dart:typed_data';
import 'package:jobpulse/base/di/get_it.dart';
import 'package:jobpulse/base/presentation/widgets/buttons/main_button.dart';
import 'package:jobpulse/base/presentation/widgets/inputs/text_input.dart';
import 'package:jobpulse/base/presentation/widgets/loader.dart';
import 'package:jobpulse/base/presentation/widgets/snackbar.dart';
import 'package:jobpulse/base/providers/user_provider.dart';
import 'package:jobpulse/base/utils/input_validators/text.dart';
import 'package:jobpulse/base/utils/pick_image.dart';
import 'package:jobpulse/user/domain/models/user.dart';
import 'package:jobpulse/user/presentation/view_models/user_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _userViewModel = getIt<UserViewModel>();
  final _userProvider = getIt<UserProvider>();
  UserModel? _user;
  bool _isLoading = false;
  Uint8List? _profileImage;

  // controllers
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _headlineController = TextEditingController();
  final _locationController = TextEditingController();
  final _skillsController = TextEditingController();
  final _bioController = TextEditingController();

  // focus nodes
  final _headlineFocusNode = FocusNode();
  final _locationFocusNode = FocusNode();
  final _skillsFocusNode = FocusNode();
  final _bioFocusNode = FocusNode();

  // errors
  String? _nameError;
  String? _headlineError;

  void selectImage () async {
    Uint8List pickedImage = await pickImage(ImageSource.gallery);
    setState(() {
      _profileImage = pickedImage;
    });
  }


  void updateProfile(context) async {
    setState(() {_isLoading = true;});
    bool successful = await _userViewModel.updateUser(
      name: _nameController.text,
      headline: _headlineController.text,
      bio: _bioController.text,
      skills: _skillsController.text,
      location: _locationController.text,
      profileImage: _profileImage,
      imageUrl: _user?.profilePic
    );

    if (successful) {
      UserModel? updatedUser = await _userViewModel.getUserDetails(null);
        setState(() {_user = updatedUser;});
        _userProvider.user = updatedUser;
      showSnackBar(context, "Profile updated successfully", Colors.green);
    } else {
      showSnackBar(context, "Something went wrong", Colors.redAccent);
    }

    setState(() {_isLoading = false;});
  }

  @override
  void initState() {
    super.initState();
    _user = Provider.of<UserProvider>(context, listen: false).user;
    _emailController.text = _user?.email ?? "";
    _nameController.text = _user?.name ?? "";
    _headlineController.text = _user?.headline ?? "";
    _locationController.text = _user?.location ?? "";
    _bioController.text = _user?.bio ?? "";
    _skillsController.text = _user?.skills ?? "";
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final nameValidator = TextValidator(context);
    final headlineValidator = TextValidator(context);

    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          backgroundColor: theme.colorScheme.primary,
          title: Text(
            "Edit Profile",
            style: theme.textTheme.headlineMedium?.copyWith(
                color: theme.colorScheme.onPrimary
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.08,),
                Center(
                  child: Stack(
                    children: [
                      _profileImage != null ? CircleAvatar(
                        radius: 60,
                        backgroundImage: MemoryImage(_profileImage!),
                      ) : _user?.profilePic != null && _user?.profilePic != "" ? CircleAvatar(
                        radius: 60,
                        backgroundImage: NetworkImage(_user!.profilePic!),
                        backgroundColor: theme.colorScheme.primary,
                      ) : CircleAvatar(
                        radius: 60,
                        backgroundImage: const AssetImage("assets/avatar.jpg"),
                        backgroundColor: theme.colorScheme.primary,
                      ),
                      Positioned(
                        bottom: 0,
                        left: 75,
                        child: GestureDetector(
                          onTap: selectImage,
                          child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary,
                              border: Border.all(
                                color: theme.colorScheme.onPrimary,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(50)
                            ),
                            child:  Icon(
                              Icons.add_a_photo,
                              color: theme.colorScheme.onPrimary
                            ),
                          ),
                        )
                      )
                    ],
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.05,),
                TextInput(
                  controller: _emailController,
                  textInputType: TextInputType.emailAddress,
                  inputAction: TextInputAction.next,
                  prefixIcon: CupertinoIcons.envelope_fill,
                  enabled: false,
                  label: "Email",
                ),
                const SizedBox(height: 15,),
                TextInput(
                  controller: _nameController,
                  textInputType: TextInputType.text,
                  inputAction: TextInputAction.next,
                  prefixIcon: CupertinoIcons.person_fill,
                  enabled: true,
                  label: "Full Name",
                  error: _nameError,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_headlineFocusNode);
                  },
                ),
                const SizedBox(height: 15,),
                TextInput(
                  controller: _headlineController,
                  textInputType: TextInputType.text,
                  inputAction: TextInputAction.next,
                  prefixIcon: CupertinoIcons.bag_fill,
                  focusNode: _headlineFocusNode,
                  enabled: true,
                  label: "Headline",
                  error: _headlineError,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_locationFocusNode);
                  },
                ),
                const SizedBox(height: 15,),
                TextInput(
                  controller: _locationController,
                  textInputType: TextInputType.text,
                  inputAction: TextInputAction.next,
                  prefixIcon: CupertinoIcons.location_solid,
                  focusNode: _locationFocusNode,
                  enabled: true,
                  label: "Location",
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_bioFocusNode);
                  },
                ),
                const SizedBox(height: 15,),
                !_user!.isCompany ? TextInput(
                  controller: _skillsController,
                  textInputType: TextInputType.text,
                  focusNode: _skillsFocusNode,
                  inputAction: TextInputAction.done,
                  enabled: true,
                  label: "Skills",
                  placeholder: "ex. Python, Figma, Flutter",
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_bioFocusNode);
                  },
                ) : Container(),
                const SizedBox(height: 15,),
                TextInput(
                  controller: _bioController,
                  textInputType: TextInputType.text,
                  height: 100.0,
                  maxLines: 5,
                  focusNode: _bioFocusNode,
                  inputAction: TextInputAction.done,
                  enabled: true,
                  label: "Bio",
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).unfocus();
                  },
                ),
                const SizedBox(height: 25,),
                _isLoading ? const Loader(size: 24) : Button(
                  onTap: () {
                    setState(() {
                      _nameError = nameValidator(_nameController.text);
                      _headlineError = headlineValidator(_headlineController.text);
                    });

                    final errors = [
                      _nameError,
                      _headlineError,
                    ];

                    if(errors.every((error) => error == null)) {
                      FocusScope.of(context).unfocus();
                      updateProfile(context);
                    }
                  },
                  text: "SAVE"
                ),
                const SizedBox(height: 25,),
              ]
            ),
          ),
        )
    );
  }
}
