import 'package:jobpulse/base/providers/user_provider.dart';
import 'package:jobpulse/job/presentation/view_models/job_view_model.dart';
import 'package:jobpulse/user/presentation/view_models/experience_view_model.dart';
import 'package:jobpulse/user/presentation/view_models/user_view_model.dart';
import 'package:get_it/get_it.dart';

final GetIt getIt = GetIt.instance;

void initialize() {
  // User
  getIt.registerLazySingleton<UserViewModel>(() => UserViewModel());
  getIt.registerSingleton<UserProvider>(UserProvider());

  // Experience
  getIt.registerLazySingleton<ExperienceViewModel>(() => ExperienceViewModel());

  // Job
  getIt.registerLazySingleton<JobViewModel>(() => JobViewModel());
}