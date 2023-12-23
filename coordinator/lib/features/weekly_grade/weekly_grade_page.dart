import 'package:core/context/navigation_extension.dart';
import 'package:core/helpers/asset_path.dart';
import 'package:core/styles/color_palette.dart';
import 'package:core/styles/text_style.dart';
import 'package:data/models/supervisors/student_unit_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:main/blocs/supervisor_cubit/supervisors_cubit.dart';
import 'package:main/widgets/custom_loading.dart';
import 'package:main/widgets/custom_shimmer.dart';
import 'package:main/widgets/inputs/search_field.dart';
import 'package:main/widgets/profile_pic_placeholder.dart';
import 'weekly_grade_detail_page.dart';

class WeeklyGradePage extends StatefulWidget {
  const WeeklyGradePage({super.key});

  @override
  State<WeeklyGradePage> createState() => _WeeklyGradePageState();
}

class _WeeklyGradePageState extends State<WeeklyGradePage> {
  ValueNotifier<List<StudentDepartmentModel>> listStudent = ValueNotifier([]);
  bool isMounted = false;
  // late final List<String> _menuList;
  // late final ValueNotifier<String> _query, _selectedMenu;

  @override
  void initState() {
    BlocProvider.of<SupervisorsCubit>(context).getAllStudentDepartment();
    // _menuList = [
    //   'All',
    //   'Inputed',
    //   'Uninputed',
    // ];

    // _query = ValueNotifier('');
    // _selectedMenu = ValueNotifier(_menuList[0]);

    super.initState();
  }

  @override
  void dispose() {
    // _query.dispose();
    // _selectedMenu.dispose();

    super.dispose();
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
                toolbarHeight: kToolbarHeight + 120,
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
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            sliver: SliverList.separated(
                              itemCount: s.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  leading: FutureBuilder(
                                    future: BlocProvider.of<SupervisorsCubit>(
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
                                        s[index].profileImage = snapshot.data;
                                        return CircleAvatar(
                                          radius: 25,
                                          foregroundImage:
                                              MemoryImage(snapshot.data!),
                                        );
                                      } else {
                                        return ProfilePicPlaceholder(
                                            height: 50,
                                            name: s[index].studentName ?? '-',
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
                                        style: textTheme.bodySmall?.copyWith(
                                          color: borderColor,
                                        ),
                                      ),
                                      RichText(
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        text: TextSpan(
                                          style: textTheme.bodySmall?.copyWith(
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
                                    WeeklyGradeDetailPage(student: s[index]),
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
                    Text(
                      'Input Score',
                      style: textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: primaryColor,
                      ),
                    ),
                    Text(
                      'Weekly Grades',
                      style: textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
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

  // SizedBox buildFilterSection() {
  //   return SizedBox(
  //     height: 64,
  //     child: ListView.separated(
  //       padding: const EdgeInsets.symmetric(horizontal: 20),
  //       scrollDirection: Axis.horizontal,
  //       itemCount: _menuList.length,
  //       itemBuilder: (context, index) {
  //         return ValueListenableBuilder(
  //           valueListenable: _selectedMenu,
  //           builder: (context, value, child) {
  //             final selected = value == _menuList[index];

  //             return RawChip(
  //               pressElevation: 0,
  //               clipBehavior: Clip.antiAlias,
  //               label: Text(_menuList[index]),
  //               labelPadding: const EdgeInsets.symmetric(horizontal: 6),
  //               labelStyle: textTheme.bodyMedium?.copyWith(
  //                 color: selected ? primaryColor : primaryTextColor,
  //               ),
  //               side: BorderSide(
  //                 color: selected ? Colors.transparent : borderColor,
  //               ),
  //               shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(10),
  //               ),
  //               selected: selected,
  //               selectedColor: primaryColor.withOpacity(.2),
  //               checkmarkColor: primaryColor,
  //               onSelected: (_) => _selectedMenu.value = _menuList[index],
  //             );
  //           },
  //         );
  //       },
  //       separatorBuilder: (_, __) => const SizedBox(width: 8),
  //     ),
  //   );
  // }
}
