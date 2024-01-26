import 'package:coordinator/features/daily_activity/daily_activity_detail_page.dart';
import 'package:coordinator/features/daily_activity/update_status_all.dart';
import 'package:core/context/navigation_extension.dart';
import 'package:core/helpers/asset_path.dart';
import 'package:core/styles/color_palette.dart';
import 'package:core/styles/text_style.dart';
import 'package:data/models/supervisors/student_unit_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:main/blocs/clinical_record_cubit/clinical_record_cubit.dart';
import 'package:main/blocs/daily_activity_cubit/daily_activity_cubit.dart';
import 'package:main/blocs/supervisor_cubit/supervisors_cubit.dart';
import 'package:main/widgets/custom_loading.dart';
import 'package:main/widgets/custom_shimmer.dart';
import 'package:main/widgets/inputs/search_field.dart';
import 'package:main/widgets/profile_pic_placeholder.dart';

class DailyActivityStudentPage extends StatefulWidget {
  const DailyActivityStudentPage({super.key});

  @override
  State<DailyActivityStudentPage> createState() =>
      _DailyActivityStudentPageState();
}

class _DailyActivityStudentPageState extends State<DailyActivityStudentPage> {
  ValueNotifier<List<StudentDepartmentModel>> listStudent = ValueNotifier([]);
  bool isMounted = false;
  @override
  void initState() {
    super.initState();
    BlocProvider.of<SupervisorsCubit>(context).getAllStudentDepartment();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => Future.wait([
          BlocProvider.of<SupervisorsCubit>(context).getAllStudentDepartment()
        ]),
        child: NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                floating: true,
                automaticallyImplyLeading: false,
                toolbarHeight: kToolbarHeight + 140,
                backgroundColor: Colors.transparent,
                surfaceTintColor: Colors.transparent,
                systemOverlayStyle: const SystemUiOverlayStyle(
                  statusBarIconBrightness: Brightness.dark,
                ),
                flexibleSpace: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    buildTitleSection(),
                    // buildFilterSection(),
                  ],
                ),
                bottom: const PreferredSize(
                  preferredSize: Size.fromHeight(6),
                  child: Divider(
                    height: 6,
                    thickness: 6,
                    color: onDisableColor,
                  ),
                ),
              ),
            ];
          },
          body: ValueListenableBuilder(
              valueListenable: listStudent,
              builder: (context, s, _) {
                return BlocSelector<DailyActivityCubit, DailyActivityState,
                    RequestState>(
                  selector: (state) => state.isStatus,
                  builder: (context, state2) {
                    return BlocConsumer<SupervisorsCubit, SupervisorsState>(
                      listener: (context, state) {
                        if (state is FetchStudentDepartmentSuccess) {
                          if (!isMounted) {
                            Future.microtask(() {
                              listStudent.value = [...state.students];
                            });
                            isMounted = true;
                          }
                        }
                      },
                      builder: (context, state) {
                        if (state is SupervisorLoading) {
                          return const CustomLoading();
                        }
                        if (state is FetchStudentDepartmentSuccess) {
                          return CustomScrollView(
                            slivers: <Widget>[
                              SliverPadding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                sliver: SliverList.separated(
                                  itemCount: s.length,
                                  itemBuilder: (context, index) {
                                    return ListTile(
                                      leading: FutureBuilder(
                                        future:
                                            BlocProvider.of<SupervisorsCubit>(
                                                    context)
                                                .getImageProfile(
                                                    id: s[index].userId ?? ''),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return CustomShimmer(
                                                child: Container(
                                              decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.white,
                                              ),
                                              width: 50,
                                              height: 50,
                                            ));
                                          } else if (snapshot.hasData) {
                                            s[index].profileImage =
                                                snapshot.data;
                                            return CircleAvatar(
                                              radius: 25,
                                              foregroundImage:
                                                  MemoryImage(snapshot.data!),
                                            );
                                          } else {
                                            return ProfilePicPlaceholder(
                                                height: 50,
                                                name:
                                                    s[index].studentName ?? '-',
                                                isSmall: true,
                                                width: 50);
                                          }
                                        },
                                      ),
                                      title: Text(
                                        s[index].studentName ?? '',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            s[index].studentId ?? '',
                                            style:
                                                textTheme.bodySmall?.copyWith(
                                              color: borderColor,
                                            ),
                                          ),
                                          RichText(
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            text: TextSpan(
                                              style:
                                                  textTheme.bodySmall?.copyWith(
                                                color: secondaryTextColor,
                                              ),
                                              children: <TextSpan>[
                                                const TextSpan(
                                                  text: 'Department:\t',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                                TextSpan(
                                                    text: s[index]
                                                        .activeDepartmentName),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      onTap: () => context.navigateTo(
                                        DailyActivityDetailPage(
                                            student: s[index]),
                                      ),
                                    );
                                  },
                                  separatorBuilder: (context, index) {
                                    return const SizedBox(height: 8);
                                  },
                                ),
                              ),
                            ],
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    );
                  },
                );
              }),
        ),
      ),
    );
  }

  Stack buildTitleSection() {
    return Stack(
      children: <Widget>[
        Positioned(
          right: 16,
          top: 0,
          child: SvgPicture.asset(
            AssetPath.getVector('circle_bg4.svg'),
          ),
        ),
        BlocBuilder<SupervisorsCubit, SupervisorsState>(
          builder: (context, state) {
            if (state is FetchStudentDepartmentSuccess) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SafeArea(
                      child: GestureDetector(
                        onTap: () => context.back(),
                        child: const Icon(
                          Icons.arrow_back_rounded,
                          color: primaryColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Manage Week',
                                style: textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: primaryColor,
                                ),
                              ),
                              Text(
                                'Daily Activity',
                                style: textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              barrierLabel: '',
                              barrierDismissible: false,
                              builder: (_) => const UpdateStatusAllDialog(
                                status: false,
                              ),
                            );
                          },
                          icon: const Icon(CupertinoIcons.settings),
                        )
                      ],
                    ),
                    const SizedBox(height: 14),
                    SearchField(
                      onChanged: (value) {
                        final data = state.students
                            .where((element) => element.studentName!
                                .toLowerCase()
                                .contains(value.toLowerCase()))
                            .toList();
                        if (value.isEmpty) {
                          listStudent.value.clear();
                          listStudent.value = [...state.students];
                        } else {
                          listStudent.value = [...data];
                        }
                      },
                      text: '',
                      hint: 'Search for student',
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }
}
