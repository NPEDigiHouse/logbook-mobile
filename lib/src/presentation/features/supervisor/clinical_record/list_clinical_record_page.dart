import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/core/helpers/asset_path.dart';
import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/core/styles/text_style.dart';
import 'package:elogbook/src/presentation/blocs/clinical_record_supervisor_cubit/clinical_record_supervisor_cubit.dart';
import 'package:elogbook/src/presentation/features/supervisor/clinical_record/clinical_record_card.dart';
import 'package:elogbook/src/presentation/features/supervisor/list_resident/list_resident_page.dart';
import 'package:elogbook/src/presentation/features/supervisor/list_resident/resident_menu_page.dart';
import 'package:elogbook/src/presentation/widgets/inkwell_container.dart';
import 'package:elogbook/src/presentation/widgets/inputs/search_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ListClinicalRecord extends StatefulWidget {
  const ListClinicalRecord({super.key});

  @override
  State<ListClinicalRecord> createState() => _ListClinicalRecordState();
}

class _ListClinicalRecordState extends State<ListClinicalRecord> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<ClinicalRecordSupervisorCubit>(context)
      ..getClinicalRecords();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Clinical Records'),
      ).variant(),
      body: SafeArea(
        child: BlocBuilder<ClinicalRecordSupervisorCubit,
            ClinicalRecordSupervisorState>(
          builder: (context, state) {
            if (state.clinicalRecords == null) {
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
                    itemCount: state.clinicalRecords!.length,
                    itemBuilder: (context, index) {
                      return ClinicalRecordCard(
                        clinicalRecord: state.clinicalRecords![index],
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
