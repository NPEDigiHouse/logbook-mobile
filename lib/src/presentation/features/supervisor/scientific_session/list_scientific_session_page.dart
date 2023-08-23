import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/core/helpers/asset_path.dart';
import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/core/styles/text_style.dart';
import 'package:elogbook/src/presentation/blocs/clinical_record_supervisor_cubit/clinical_record_supervisor_cubit.dart';
import 'package:elogbook/src/presentation/blocs/scientific_session_supervisor_cubit/scientific_session_supervisor_cubit.dart';
import 'package:elogbook/src/presentation/features/supervisor/clinical_record/clinical_record_card.dart';
import 'package:elogbook/src/presentation/features/supervisor/list_resident/list_resident_page.dart';
import 'package:elogbook/src/presentation/features/supervisor/list_resident/resident_menu_page.dart';
import 'package:elogbook/src/presentation/features/supervisor/scientific_session/clinical_record_card.dart';
import 'package:elogbook/src/presentation/widgets/inkwell_container.dart';
import 'package:elogbook/src/presentation/widgets/inputs/search_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ListScientificSessionPage extends StatefulWidget {
  const ListScientificSessionPage({super.key});

  @override
  State<ListScientificSessionPage> createState() =>
      _ListScientificSessionPageState();
}

class _ListScientificSessionPageState extends State<ListScientificSessionPage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<ScientificSessionSupervisorCubit>(context)
      ..getScientificSessionList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scientific Session'),
      ).variant(),
      body: SafeArea(
        child: BlocBuilder<ScientificSessionSupervisorCubit,
            ScientificSessionSupervisorState>(
          builder: (context, state) {
            if (state.listData == null) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 16,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: SearchField(
                      onChanged: (value) {},
                      text: 'Search',
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 16,
                    ),
                  ),
                  SliverList.separated(
                    itemCount: state.listData!.length,
                    itemBuilder: (context, index) {
                      return ScientificSessionCard(
                        scientificSession: state.listData![index],
                      );
                    },
                    separatorBuilder: (context, index) {
                      return SizedBox(
                        height: 12,
                      );
                    },
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildStudentCard(BuildContext context, StudentDummyHelper student) {
    return InkWellContainer(
      color: Colors.white,
      onTap: () => context.navigateTo(ResidentMenuPage()),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            foregroundImage: AssetImage(
              AssetPath.getImage('profile_default.png'),
            ),
          ),
          SizedBox(
            width: 12,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                student.name,
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: primaryTextColor,
                ),
              ),
              Text(
                student.id,
                style: textTheme.bodyMedium?.copyWith(
                  color: secondaryTextColor,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
