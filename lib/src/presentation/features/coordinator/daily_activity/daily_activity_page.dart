import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/src/presentation/blocs/unit_cubit/unit_cubit.dart';
import 'package:elogbook/src/presentation/features/coordinator/daily_activity/daily_activity_add_week_page.dart';
import 'package:elogbook/src/presentation/widgets/custom_loading.dart';
import 'package:elogbook/src/presentation/widgets/dividers/item_divider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CoordinatorDailyActivityPage extends StatefulWidget {
  const CoordinatorDailyActivityPage({super.key});

  @override
  State<CoordinatorDailyActivityPage> createState() =>
      _CoordinatorDailyActivityPageState();
}

class _CoordinatorDailyActivityPageState
    extends State<CoordinatorDailyActivityPage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<DepartmentCubit>(context, listen: false)
      ..fetchDepartments(true);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Departments'),
      ).variant(),
      body: RefreshIndicator(
        onRefresh: () => Future.wait([
          BlocProvider.of<DepartmentCubit>(context, listen: false)
              .fetchDepartments(true),
        ]),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              BlocBuilder<DepartmentCubit, DepartmentState>(
                builder: (context, state) {
                  if (state is FetchSuccess)
                    return SliverList.separated(
                      separatorBuilder: (context, index) {
                        return ItemDivider();
                      },
                      itemCount: state.units.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          onTap: () {
                            context.navigateTo(DailyActivityAddWeekPage(
                              unit: state.units[index],
                            ));
                          },
                          title: Text(state.units[index].name),
                        );
                      },
                    );
                  return SliverFillRemaining(child: CustomLoading());
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
