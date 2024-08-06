import 'package:jobpulse/base/di/get_it.dart';
import 'package:jobpulse/base/presentation/widgets/buttons/main_button.dart';
import 'package:jobpulse/base/presentation/widgets/inputs/password_input.dart';
import 'package:jobpulse/base/presentation/widgets/inputs/select_input.dart';
import 'package:jobpulse/base/presentation/widgets/inputs/text_input.dart';
import 'package:jobpulse/base/presentation/widgets/loader.dart';
import 'package:jobpulse/base/presentation/widgets/snackbar.dart';
import 'package:jobpulse/base/utils/input_validators/email.dart';
import 'package:jobpulse/base/utils/input_validators/password.dart';
import 'package:jobpulse/base/utils/input_validators/text.dart';
import 'package:jobpulse/user/presentation/screens/login_screen.dart';
import 'package:jobpulse/user/presentation/view_models/user_view_model.dart';
import 'package:jobpulse/user/presentation/widgets/bottom_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final  _viewModel = getIt<UserViewModel>();
  bool _isLoading = false;
  bool _isCompany = false;

  // controllers
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _headlineController = TextEditingController();
  final _locationController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // focus nodes
  final _nameFocusNode = FocusNode();
  final _headlineFocusNode = FocusNode();
  final _locationFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();

  // errors
  String? _emailError;
  String? _nameError;
  String? _headlineError;
  String? _locationError;
  String? _passwordError;
  String? _confirmPasswordError;

  void registerUser(context) async {
    setState(() { _isLoading = true; });

    bool successful = await _viewModel.registerUser(
      email: _emailController.text,
      password: _passwordController.text,
      name: _nameController.text,
      headline: _headlineController.text,
      location: _locationController.text,
      isCompany: _isCompany
    );

    setState(() { _isLoading = false; });

    if(successful) {
      _emailController.clear();
      _nameController.clear();
      _headlineController.clear();
      _passwordController.clear();
      _confirmPasswordController.clear();

      showSnackBar(
        context,
        "User registered successfully, please login to continue",
        Colors.green
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen())
      );
    } else {
      showSnackBar(
        context,
        "User registration failed, something went wrong",
        Colors.redAccent
      );
    }
  }

  @override void dispose() {
    super.dispose();
    _emailController.dispose();
    _nameController.dispose();
    _headlineController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final emailValidator = EmailValidator(context);
    final nameValidator = TextValidator(context);
    final headlineValidator = TextValidator(context);
    final locationValidator = TextValidator(context);
    final passwordValidator = PasswordValidator(context, false);
    final confirmPasswordValidator = PasswordValidator(context, true);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.18,),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.22,
                  child: Center(
                    child: Column(
                      children: [
                        Image.asset(
                          "assets/logo.png",
                          color: theme.colorScheme.primary,
                          height: 100,
                        ),
                        const SizedBox(height: 15,),
                        Text(
                            "Put Me On",
                            style: GoogleFonts.robotoCondensed(
                                fontSize: 40,
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.w800,
                                fontStyle: FontStyle.italic
                            )
                        ),
                      ],
                    )
                  ),
                ),
                TextInput(
                  controller: _emailController,
                  textInputType: TextInputType.emailAddress,
                  inputAction: TextInputAction.next,
                  prefixIcon: CupertinoIcons.envelope_fill,
                  placeholder: "ex. johndoe@gmail.com",
                  label: "Email",
                  error: _emailError,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_nameFocusNode);
                  },
                ),
                const SizedBox(height: 15,),
                TextInput(
                  controller: _nameController,
                  textInputType: TextInputType.text,
                  focusNode: _nameFocusNode,
                  inputAction: TextInputAction.next,
                  prefixIcon: CupertinoIcons.person_fill,
                  label: "Full Name",
                  placeholder: "ex. John Doe / COMPANY NAME",
                  error: _nameError,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_headlineFocusNode);
                  },
                ),
                const SizedBox(height: 15,),
                SelectInput(
                  controller: _headlineController,
                  focusNode: _headlineFocusNode,
                  inputAction: TextInputAction.next,
                  prefixIcon: CupertinoIcons.bag_fill,
                  label: "Industry",
                  placeholder: "ex. Manufacturing",
                  dialogTitle: "Select Industry",
                  error: _headlineError,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_locationFocusNode);
                  },
                  options: const [
                    "Manufacturing",
                    "Technology",
                    "Healthcare",
                    "Finance",
                    "Retail",
                    "Transportation",
                    "Energy",
                    "Education",
                    "Construction",
                    "Agriculture",
                    "Public Sector",
                    "Service Industries",
                    "Other"
                  ],
                ),
                const SizedBox(height: 15,),
                SelectInput(
                  controller: _locationController,
                  focusNode: _locationFocusNode,
                  inputAction: TextInputAction.next,
                  prefixIcon: CupertinoIcons.location_solid,
                  label: "Location",
                  placeholder: "ex. Greater Accra",
                  dialogTitle: "Select Location",
                  error: _locationError,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_passwordFocusNode);
                  },
                  options: const [
                    "Ashanti Region",
                    "Greater Accra Region",
                    "Eastern Region",
                    "Central Region",
                    "Western Region",
                    "Volta Region",
                    "Northern Region",
                    "Brong Ahafo Region",
                    "Upper East Region",
                    "Upper West Region",
                    "Oti Region",
                    "Savannah Region",
                    "North East Region",
                    "Ahafo Region",
                    "Western North Region",
                    "Bono East Region"
                  ],
                ),
                const SizedBox(height: 15,),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Signing up as a company?", style: theme.textTheme.bodyMedium),
                    const SizedBox(width: 5,),
                    Switch(
                        activeColor: theme.colorScheme.primary,
                        activeTrackColor: theme.colorScheme.primary.withOpacity(0.4),
                        value: _isCompany,
                        onChanged: (value) {
                          setState(() {
                            _isCompany = value;
                          });
                        }
                    ),
                  ],
                ),
                const SizedBox(height: 15,),
                PasswordInput(
                  controller: _passwordController,
                  focusNode: _passwordFocusNode,
                  inputAction: TextInputAction.next,
                  error: _passwordError,
                  label: "Password",
                  placeholder: "Type your password",
                  showIcon: true,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_confirmPasswordFocusNode);
                  },
                ),
                const SizedBox(height: 15,),
                PasswordInput(
                  controller: _confirmPasswordController,
                  focusNode: _confirmPasswordFocusNode,
                  inputAction: TextInputAction.done,
                  error: _confirmPasswordError,
                  label: "Confirm Password",
                  placeholder: "Confirm your password",
                  showIcon: true,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).unfocus();
                  },
                ),
                const SizedBox(height: 25,),
                _isLoading ? const Loader(size: 24)  : Button(
                  onTap: () {
                    setState(() {
                      _emailError = emailValidator(_emailController.text);
                      _nameError = nameValidator(_nameController.text);
                      _passwordError = passwordValidator(_passwordController.text, null);
                      _headlineError = headlineValidator(_headlineController.text);
                      _locationError = locationValidator(_locationController.text);
                      _confirmPasswordError = confirmPasswordValidator(
                          _confirmPasswordController.text,
                          _passwordController.text
                      );
                    });

                    final errors = [
                      _emailError,
                      _nameError,
                      _passwordError,
                      _headlineError,
                      _locationError,
                      _confirmPasswordError
                    ];

                    if(errors.every((error) => error == null)) {
                      FocusScope.of(context).unfocus();
                      registerUser(context);
                    }
                  },
                  text: "REGISTER"
                ),
                BottomInfo(
                  info: "Already have an account ?",
                  btnText: "LOGIN",
                  action: () {
                    Navigator.pop(context);
                  }
                ),
              ],
            ),
          ),
        )
      ),
    );
  }
}
