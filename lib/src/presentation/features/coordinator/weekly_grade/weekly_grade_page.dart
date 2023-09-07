import 'package:elogbook/src/presentation/blocs/supervisor_cubit/supervisors_cubit.dart';
import 'package:elogbook/src/presentation/widgets/custom_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/core/helpers/asset_path.dart';
import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/core/styles/text_style.dart';
import 'package:elogbook/src/presentation/features/coordinator/weekly_grade/weekly_grade_detail_page.dart';
import 'package:elogbook/src/presentation/widgets/inputs/search_field.dart';

class WeeklyGradePage extends StatefulWidget {
  const WeeklyGradePage({super.key});

  @override
  State<WeeklyGradePage> createState() => _WeeklyGradePageState();
}

class _WeeklyGradePageState extends State<WeeklyGradePage> {
  late final List<String> _menuList;
  late final ValueNotifier<String> _query, _selectedMenu;

  @override
  void initState() {
    BlocProvider.of<SupervisorsCubit>(context)..getAllStudentDepartment();
    _menuList = [
      'All',
      'Inputed',
      'Uninputed',
    ];

    _query = ValueNotifier('');
    _selectedMenu = ValueNotifier(_menuList[0]);

    super.initState();
  }

  @override
  void dispose() {
    _query.dispose();
    _selectedMenu.dispose();

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
                toolbarHeight: kToolbarHeight + 190,
                backgroundColor: Colors.transparent,
                surfaceTintColor: Colors.transparent,
                systemOverlayStyle: const SystemUiOverlayStyle(
                  statusBarIconBrightness: Brightness.dark,
                ),
                flexibleSpace: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    buildTitleSection(),
                    buildFilterSection(),
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
          body: BlocBuilder<SupervisorsCubit, SupervisorsState>(
            builder: (context, state) {
              if (state is Loading) {
                return CustomLoading();
              }
              if (state is FetchStudentDepartmentSuccess)
                return CustomScrollView(
                  slivers: <Widget>[
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      sliver: SliverList.separated(
                        itemCount: state.students.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: CircleAvatar(
                              radius: 32,
                              foregroundImage: AssetImage(
                                AssetPath.getImage('profile_default.png'),
                              ),
                            ),
                            title: Text(
                              state.students[index].studentName ?? '',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: Text(
                              state.students[index].studentId ?? '',
                              style: textTheme.bodySmall?.copyWith(
                                color: borderColor,
                              ),
                            ),
                            onTap: () => context.navigateTo(
                              WeeklyGradeDetailPage(
                                  student: state.students[index]),
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
              return SizedBox.shrink();
            },
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
        Padding(
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
              ValueListenableBuilder(
                valueListenable: _query,
                builder: (context, query, child) {
                  return SearchField(
                    text: query,
                    onChanged: (value) => _query.value = value,
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  SizedBox buildFilterSection() {
    return SizedBox(
      height: 64,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: _menuList.length,
        itemBuilder: (context, index) {
          return ValueListenableBuilder(
            valueListenable: _selectedMenu,
            builder: (context, value, child) {
              final selected = value == _menuList[index];

              return RawChip(
                pressElevation: 0,
                clipBehavior: Clip.antiAlias,
                label: Text(_menuList[index]),
                labelPadding: const EdgeInsets.symmetric(horizontal: 6),
                labelStyle: textTheme.bodyMedium?.copyWith(
                  color: selected ? primaryColor : primaryTextColor,
                ),
                side: BorderSide(
                  color: selected ? Colors.transparent : borderColor,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                selected: selected,
                selectedColor: primaryColor.withOpacity(.2),
                checkmarkColor: primaryColor,
                onSelected: (_) => _selectedMenu.value = _menuList[index],
              );
            },
          );
        },
        separatorBuilder: (_, __) => const SizedBox(width: 8),
      ),
    );
  }
}
