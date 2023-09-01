import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/src/data/models/clinical_records/clinical_record_list_model.dart';
import 'package:elogbook/src/presentation/blocs/clinical_record_supervisor_cubit/clinical_record_supervisor_cubit.dart';
import 'package:elogbook/src/presentation/features/supervisor/clinical_record/clinical_record_card.dart';
import 'package:elogbook/src/presentation/widgets/custom_loading.dart';
import 'package:elogbook/src/presentation/widgets/inputs/search_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SupervisorListClinicalRecord extends StatefulWidget {
  const SupervisorListClinicalRecord({super.key});

  @override
  State<SupervisorListClinicalRecord> createState() =>
      _SupervisorListClinicalRecordState();
}

class _SupervisorListClinicalRecordState
    extends State<SupervisorListClinicalRecord> {
  ValueNotifier<List<ClinicalRecordListModel>> listStudent = ValueNotifier([]);
  bool isMounted = false;
  @override
  void initState() {
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
        child: RefreshIndicator(
          onRefresh: () async {
            await Future.wait([
              BlocProvider.of<ClinicalRecordSupervisorCubit>(context)
                  .getClinicalRecords(),
            ]);
          },
          child: ValueListenableBuilder(
              valueListenable: listStudent,
              builder: (context, s, _) {
                return BlocBuilder<ClinicalRecordSupervisorCubit,
                    ClinicalRecordSupervisorState>(
                  builder: (context, state) {
                    if (state.clinicalRecords == null) {
                      return CustomLoading();
                    }
                    if (!isMounted) {
                      Future.microtask(() {
                        listStudent.value = [...state.clinicalRecords!];
                      });
                      isMounted = true;
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
                              onChanged: (value) {
                                final data = state.clinicalRecords!
                                    .where((element) => element.studentName!
                                        .toLowerCase()
                                        .contains(value.toLowerCase()))
                                    .toList();
                                if (value.isEmpty) {
                                  listStudent.value.clear();
                                  listStudent.value = [
                                    ...state.clinicalRecords!
                                  ];
                                } else {
                                  listStudent.value = [...data];
                                }
                              },
                              text: 'Search',
                            ),
                          ),
                          SliverToBoxAdapter(
                            child: SizedBox(
                              height: 16,
                            ),
                          ),
                          SliverList.separated(
                            itemCount: s.length,
                            itemBuilder: (context, index) {
                              return ClinicalRecordCard(
                                clinicalRecord: s[index],
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
                );
              }),
        ),
      ),
    );
  }
}
