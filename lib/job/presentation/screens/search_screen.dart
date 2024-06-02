import 'dart:async';
import 'package:jobpulse/base/di/get_it.dart';
import 'package:jobpulse/base/presentation/widgets/empty_list_placeholder.dart';
import 'package:jobpulse/base/presentation/widgets/loader.dart';
import 'package:jobpulse/job/domain/models/job.dart';
import 'package:jobpulse/job/presentation/screens/job_detail_screen.dart';
import 'package:jobpulse/job/presentation/view_models/job_view_model.dart';
import 'package:jobpulse/user/domain/models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jobpulse/user/presentation/screens/profile_screen.dart';
import 'package:jobpulse/user/presentation/view_models/user_view_model.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key, required this.user});

  final UserModel user;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _jobViewModel = getIt<JobViewModel>();
  final _userViewModel = getIt<UserViewModel>();
  bool _isLoading = false;
  List<SearchItem> _items = [];
  static const int debounceDuration = 500;
  Timer? _debounceTimer;
  final _searchController = TextEditingController();

  void _search(String keyword) {
    if (_debounceTimer != null) _debounceTimer!.cancel();

    _debounceTimer = Timer(const Duration(milliseconds: debounceDuration), () async {
      List<SearchItem> items = [];
      setState(() {_isLoading = true;});
      List<JobModel?>? jobs =  await _jobViewModel.searchJobs(keyword, widget.user.location!);
      List<UserModel?>? users =  await _userViewModel.searchUsers(keyword, widget.user);
      debugPrint(users.toString());

      if(jobs != null) {
        for (var job in jobs) {
          items.add(
            SearchItem(
              type: "job",
              content: job,
              title: job!.jobTitle,
              headline: job.companyName,
              subtitle: job.description,
              image: job.userProfilePic
            )
          );
        }
      }

      if(users != null) {
        for (var user in users) {
          items.add(
            SearchItem(
              type: "user",
              content: user,
              title: user!.name,
              headline: user.headline,
              subtitle: "Skills: ${user.skills ?? "None"} \n Bio: ${user.bio ?? "None"}",
              image: user.profilePic
            )
          );
        }
      }

      items.sort((a, b) => a.title.compareTo(b.title));
      setState(() {_items = items; _isLoading = false;});
    });
  }




  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: theme.colorScheme.primary,
        title: Text(
          "Put Me On",
          style: theme.textTheme.headlineMedium?.copyWith(
              color: theme.colorScheme.onPrimary
          ),
        ),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          TextFormField(
            controller: _searchController,
            onChanged: (keyword) => _search(keyword),
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.done,
            maxLines:1,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface,
            ),
            decoration: InputDecoration(
              hintText: "Search",
              hintStyle: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.5),
              ),
              fillColor: theme.colorScheme.surface,
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.transparent
                )
              ),
              disabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.transparent
                )
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.transparent
                )
              ),
              prefixIcon: Icon(CupertinoIcons.search, color: theme.colorScheme.primary,),
            ),
          ),
          Expanded(
            child: _isLoading ? const Center(child: Loader(size: 30),) : _items.isNotEmpty ? ListView.builder(
              scrollDirection: Axis.vertical,
              padding: const EdgeInsets.all(8),
              itemCount: _items.length,
              itemBuilder: (context, index) {
                SearchItem item = _items[index];
                return SearchCard(
                  type: item.type,
                  title: item.title,
                  subtitle: item.subtitle,
                  headline: item.headline,
                  job: item.type == "job" ? item.content as JobModel : null,
                  user: item.type == "user" ? item.content as UserModel : null,
                );
              }
            ) : const EmptyListPlaceholder(
              icon: CupertinoIcons.bag_fill,
              message: "No jobs or professionals available at this time.",
            ),
          ),
        ],
      ),
    );
  }
}



class SearchCard extends StatelessWidget {
  const SearchCard({
    super.key,
    required this.type,
    this.image,
    required this.title,
    required this.subtitle,
    required this.headline,
    this.user,
    this.job
  });

  final String type;
  final String? image;
  final String title;
  final String subtitle;
  final String headline;
  final UserModel? user;
  final JobModel? job;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: () async {
        if(type == "job") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => JobDetailScreen(job: job!)
            )
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProfileScreen(user: user!, myProfile: false,)
            )
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Container(
          height: 150,
          decoration: BoxDecoration(
            color: theme.colorScheme.background,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.onBackground.withOpacity(0.2),
                spreadRadius: 0.8,
                blurRadius: 1,
                blurStyle: BlurStyle.normal
              )
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    image != null && image != "" ? CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(image!),
                      backgroundColor: theme.colorScheme.primary,
                    ) : CircleAvatar(
                      radius: 20,
                      backgroundImage: const AssetImage("assets/avatar.jpg"),
                      backgroundColor: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 9,),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                title,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.bold
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                type == "job" ? "Job" : "Professional",
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.primary
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                          Text(
                            headline,
                            style: theme.textTheme.bodyMedium
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8,),
                Text(
                  subtitle,
                  style: theme.textTheme.bodyMedium
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SearchItem {
  final String type;
  final String? image;
  final String title;
  final String headline;
  final String subtitle;
  final dynamic content;

  const SearchItem({
    required this.type,
    required this.content,
    required this.headline,
    this.image,
    required this.title,
    required this.subtitle,
  });
}