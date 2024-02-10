import 'package:core/context/navigation_extension.dart';
import 'package:core/helpers/asset_path.dart';
import 'package:core/styles/color_palette.dart';
import 'package:core/styles/text_style.dart';
import 'package:data/models/supervisors/student_unit_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:main/blocs/clinical_record_cubit/clinical_record_cubit.dart';
import 'package:main/blocs/supervisor_cubit/supervisors_cubit.dart';
import 'package:main/blocs/supervisor_cubit2/supervisors_cubit2.dart';
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
  late int page;
  String? query;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    page = 1;
    Future.microtask(() => BlocProvider.of<SupervisorCubit2>(context)
        .getAllStudentDepartment(page: page));
  }

  void _onScroll() {
    final state = context.read<SupervisorCubit2>().state.state;
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        state != RequestState.loading) {
      _loadMoreData();
    }
  }

  void _loadMoreData() {
    BlocProvider.of<SupervisorCubit2>(context).getAllStudentDepartment(
      query: query,
      page: page + 1,
      onScroll: true,
    );
    page++;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => Future.wait([
            BlocProvider.of<SupervisorCubit2>(context)
                .getAllStudentDepartment(page: page, query: query),
          ]),
          child: NestedScrollView(
            floatHeaderSlivers: true,
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  floating: true,
                  snap: true,
                  automaticallyImplyLeading: false,
                  toolbarHeight: kToolbarHeight + 120,
                  backgroundColor: scaffoldBackgroundColor,
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
            body: BlocSelector<SupervisorCubit2, SupervisorState2,
                (List<StudentDepartmentModel>?, RequestState)>(
              selector: (state) => (state.listData, state.state),
              builder: (context, state) {
                final data = state.$1;

                if (data == null || state.$2 == RequestState.loading) {
                  return const CustomLoading();
                }
                return CustomScrollView(
                  slivers: <Widget>[
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      sliver: SliverList.separated(
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: FutureBuilder(
                              future: BlocProvider.of<SupervisorsCubit>(context)
                                  .getImageProfile(
                                      id: data[index].userId ?? ''),
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
                                  data[index].profileImage = snapshot.data;
                                  return CircleAvatar(
                                    radius: 25,
                                    foregroundImage:
                                        MemoryImage(snapshot.data!),
                                  );
                                } else {
                                  return ProfilePicPlaceholder(
                                      height: 50,
                                      name: data[index].studentName ?? '-',
                                      isSmall: true,
                                      width: 50);
                                }
                              },
                            ),
                            title: Text(
                              data[index].studentName ?? '',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data[index].studentId ?? '',
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
                                          text:
                                              data[index].activeDepartmentName),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            onTap: () => context.navigateTo(
                              WeeklyGradeDetailPage(student: data[index]),
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
              },
            ),
          ),
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
        BlocBuilder<SupervisorCubit2, SupervisorState2>(
          builder: (context, state) {
            if (state.state == RequestState.data || state.listData != null) {
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
                      onClear: () {
                        query = null;
                        context
                            .read<SupervisorCubit2>()
                            .getAllStudentDepartment(
                              page: page,
                              query: query,
                            );
                      },
                      onChanged: (value) {
                        query = value;
                        context
                            .read<SupervisorCubit2>()
                            .getAllStudentDepartment(
                              page: page,
                              query: query,
                            );
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
