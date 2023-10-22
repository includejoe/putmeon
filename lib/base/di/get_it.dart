import 'package:jobpulse/base/providers/user_provider.dart';
import 'package:jobpulse/job/presentation/view_models/job_view_model.dart';
import 'package:jobpulse/user/presentation/view_models/experience_view_model.dart';
import 'package:jobpulse/user/presentation/view_models/user_view_model.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GetIt getIt = GetIt.instance;

void initialize() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  // User
  getIt.registerLazySingleton<UserViewModel>(() => UserViewModel());
  getIt.registerSingleton<UserProvider>(UserProvider(sharedPreferences));

  // Experience
  getIt.registerLazySingleton<ExperienceViewModel>(() => ExperienceViewModel());

  // Job
  getIt.registerLazySingleton<JobViewModel>(() => JobViewModel());
}