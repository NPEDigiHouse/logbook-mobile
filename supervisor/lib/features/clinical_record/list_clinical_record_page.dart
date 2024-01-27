import 'package:core/context/navigation_extension.dart';
import 'package:core/styles/color_palette.dart';
import 'package:core/styles/text_style.dart';
import 'package:data/models/clinical_records/clinical_record_list_model.dart';
import 'package:data/utils/filter_type.dart';
import 'package:flutter/cupertino.dart';
import 'package:main/blocs/clinical_record_cubit/clinical_record_cubit.dart';
import 'package:main/blocs/clinical_record_supervisor_cubit/clinical_record_supervisor_cubit.dart';
import 'package:main/widgets/custom_loading.dart';
import 'package:main/widgets/empty_data.dart';
import 'package:main/widgets/inputs/search_field.dart';
import 'package:provider/provider.dart';
import 'package:supervisor/features/sgl_cst/widgets/select_department_sheet.dart';
import 'package:supervisor/helpers/notifier/filter_notifier.dart';

import 'clinical_record_card.dart';
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
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FilterNotifier(),
      child: _SupervisorListClinicalRecordView(),
    );
  }
}

class _SupervisorListClinicalRecordView extends StatefulWidget {
  @override
  State<_SupervisorListClinicalRecordView> createState() =>
      __SupervisorListClinicalRecordViewState();
}

class __SupervisorListClinicalRecordViewState
    extends State<_SupervisorListClinicalRecordView> {
  late int page;
  String? query;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    page = 1;
    BlocProvider.of<ClinicalRecordSupervisorCubit>(context).getClinicalRecords(
      page: page,
    );
  }

  void _onScroll() {
    final state =
        context.read<ClinicalRecordSupervisorCubit>().state.fetchState;
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        state != RequestState.loading) {
      _loadMoreData();
    }
  }

  void _loadMoreData() {
    final d = context.read<FilterNotifier>();
    BlocProvider.of<ClinicalRecordSupervisorCubit>(context).getClinicalRecords(
      unitId: d.unit?.id,
      query: query,
      page: page + 1,
      onScroll: true,
      type: d.filterType,
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
    return Consumer<FilterNotifier>(builder: (context, ntf, _) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Clinical Records'),
          actions: [
            IconButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isDismissible: true,
                  builder: (ctx) => SelectDepartmentSheet(
                    initUnit: ntf.unit,
                    filterType: ntf.filterType,
                    onTap: (f, u) {
                      // filterUnitId = f;
                      context.read<FilterNotifier>().setFilterType = f;
                      context.read<FilterNotifier>().setDepartmentModel = u;
                      page = 1;
                      BlocProvider.of<ClinicalRecordSupervisorCubit>(context)
                          .getClinicalRecords(
                              unitId: u?.id, query: query, page: page, type: f);
                      Navigator.pop(context);
                    },
                  ),
                );
              },
              icon: const Icon(
                CupertinoIcons.line_horizontal_3_decrease,
              ),
            )
          ],
        ).variant(),
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: () async {
              page = 1;
              await Future.wait([
                BlocProvider.of<ClinicalRecordSupervisorCubit>(context)
                    .getClinicalRecords(
                        unitId: ntf.unit?.id, page: page, query: query),
              ]);
            },
            child: BlocSelector<
                ClinicalRecordSupervisorCubit,
                ClinicalRecordSupervisorState,
                (List<ClinicalRecordListModel>?, RequestState)>(
              selector: (state) => (state.clinicalRecords, state.fetchState),
              builder: (context, state) {
                final data = state.$1;

                if (data == null || state.$2 == RequestState.loading) {
                  return const CustomLoading();
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: CustomScrollView(
                    controller: _scrollController,
                    slivers: [
                      const SliverToBoxAdapter(
                        child: SizedBox(
                          height: 16,
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: SearchField(
                          onClear: () {
                            query = null;
                            context
                                .read<ClinicalRecordSupervisorCubit>()
                                .getClinicalRecords(
                                    unitId: ntf.unit?.id,
                                    page: page,
                                    query: query,
                                    type: ntf.filterType);
                          },
                          onChanged: (value) {
                            query = value;
                            context
                                .read<ClinicalRecordSupervisorCubit>()
                                .getClinicalRecords(
                                    unitId: ntf.unit?.id,
                                    page: page,
                                    query: query,
                                    type: ntf.filterType);
                          },
                          text: 'Search',
                        ),
                      ),
                      const SliverToBoxAdapter(
                        child: SizedBox(
                          height: 8,
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: SizedBox(
                          child: SingleChildScrollView(
                            child: Row(
                              children: [
                                if (ntf.filterType != FilterType.all)
                                  Chip(
                                    backgroundColor:
                                        primaryColor.withOpacity(.1),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      side: BorderSide.none,
                                    ),
                                    side: BorderSide(
                                        color: secondaryColor.withOpacity(.5)),
                                    label: Text(
                                        ntf.filterType.name.toCapitalize()),
                                    labelStyle: textTheme.bodyMedium
                                        ?.copyWith(color: primaryColor),
                                    deleteIcon: const Icon(
                                      Icons.close_rounded,
                                      color: primaryColor,
                                      size: 16,
                                    ),
                                    onDeleted: () {
                                      context
                                          .read<FilterNotifier>()
                                          .setFilterType = FilterType.all;
                                      BlocProvider.of<
                                                  ClinicalRecordSupervisorCubit>(
                                              context)
                                          .getClinicalRecords(
                                              unitId: ntf.unit?.id,
                                              page: page,
                                              query: query,
                                              type: ntf.filterType);
                                    },
                                  ),
                                const SizedBox(
                                  width: 8,
                                ),
                                if (ntf.unit != null)
                                  Chip(
                                    backgroundColor:
                                        primaryColor.withOpacity(.1),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      side: BorderSide.none,
                                    ),
                                    side: BorderSide(
                                        color: secondaryColor.withOpacity(.5)),
                                    label: Text(
                                        '${ntf.unit?.name.toCapitalize()}'),
                                    labelStyle: textTheme.bodyMedium
                                        ?.copyWith(color: primaryColor),
                                    deleteIcon: const Icon(
                                      Icons.close_rounded,
                                      color: primaryColor,
                                      size: 16,
                                    ),
                                    onDeleted: () {
                                      context
                                          .read<FilterNotifier>()
                                          .setDepartmentModel = null;
                                      BlocProvider.of<
                                                  ClinicalRecordSupervisorCubit>(
                                              context)
                                          .getClinicalRecords(
                                              unitId: ntf.unit?.id,
                                              page: page,
                                              query: query,
                                              type: ntf.filterType);
                                    },
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      data.isNotEmpty
                          ? SliverList.separated(
                              itemCount: data.length,
                              itemBuilder: (context, index) {
                                return ClinicalRecordCard(
                                  clinicalRecord: data[index],
                                );
                              },
                              separatorBuilder: (context, index) {
                                return const SizedBox(
                                  height: 12,
                                );
                              },
                            )
                          : const SliverToBoxAdapter(
                              child: EmptyData(
                                  title: 'Empty Data',
                                  subtitle: 'No clinical record found'),
                            )
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      );
    });
  }
}
