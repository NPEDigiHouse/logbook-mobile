// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:core/helpers/utils.dart';
import 'package:core/styles/color_palette.dart';
import 'package:data/models/reference/reference_on_list_model.dart';
import 'package:data/models/units/active_unit_model.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:main/blocs/reference/reference_cubit.dart';
import 'package:main/widgets/custom_alert.dart';
import 'package:main/widgets/custom_loading.dart';
import 'package:main/widgets/empty_data.dart';
import 'package:main/widgets/headers/unit_header.dart';
import 'package:main/widgets/inkwell_container.dart';
import 'package:main/widgets/inputs/search_field.dart';
import 'package:main/widgets/spacing_column.dart';
import 'package:path/path.dart' as p;
import 'package:permission_handler/permission_handler.dart';

class ReferencePage extends StatefulWidget {
  final ActiveDepartmentModel activeDepartmentModel;

  const ReferencePage({super.key, required this.activeDepartmentModel});

  @override
  State<ReferencePage> createState() => _ReferencePageState();
}

class _ReferencePageState extends State<ReferencePage> {
  ValueNotifier<List<ReferenceOnListModel>> listData = ValueNotifier([]);
  bool isMounted = false;

  Future<bool> checkAndRequestPermission() async {
    PermissionStatus? status;

    if (Platform.isAndroid) {
      final plugin = DeviceInfoPlugin();
      final android = await plugin.androidInfo;

      status = android.version.sdkInt < 33
          ? await Permission.storage.request()
          : PermissionStatus.granted;
    } else {
      status = await Permission.storage.request();
    }
    return status.isGranted;
  }

  @override
  void initState() {
    super.initState();
    BlocProvider.of<ReferenceCubit>(context)
      .getListReference(unitId: widget.activeDepartmentModel.unitId!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("References"),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await Future.wait([
              BlocProvider.of<ReferenceCubit>(context).getListReference(
                  unitId: widget.activeDepartmentModel.unitId!),
            ]);
          },
          child: ValueListenableBuilder(
              valueListenable: listData,
              builder: (context, s, _) {
                return CustomScrollView(
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      sliver: SliverToBoxAdapter(
                        child: SpacingColumn(
                          onlyPading: true,
                          horizontalPadding: 16,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                DepartmentHeader(
                                  unitName:
                                      widget.activeDepartmentModel.unitName!,
                                ),
                                BlocConsumer<ReferenceCubit, ReferenceState>(
                                  listener: (context, state) {
                                    if (state.rData != null) {
                                      CustomAlert.success(
                                          message:
                                              'Success download data ${state.rData}',
                                          context: context);

                                      BlocProvider.of<ReferenceCubit>(context)
                                          .reset();
                                    }
                                    if (state.references != null) {
                                      if (!isMounted) {
                                        Future.microtask(() {
                                          listData.value = [
                                            ...state.references!
                                          ];
                                          isMounted = true;
                                        });
                                      }
                                    }
                                  },
                                  builder: (context, state) {
                                    if (state.references != null) {
                                      if (state.references!.isNotEmpty) {
                                        return Column(
                                          children: [
                                            const SizedBox(
                                              height: 24,
                                            ),
                                            SearchField(
                                              onChanged: (String value) {
                                                final data = state.references!
                                                    .where((element) => element
                                                        .file!
                                                        .toLowerCase()
                                                        .contains(value
                                                            .toLowerCase()))
                                                    .toList();
                                                if (value.isEmpty) {
                                                  listData.value.clear();
                                                  listData.value = [
                                                    ...state.references!
                                                  ];
                                                } else {
                                                  listData.value = [...data];
                                                }
                                              },
                                              text: 'Search',
                                            ),
                                            const SizedBox(
                                              height: 24,
                                            ),
                                            if (s.isNotEmpty)
                                              ListView.separated(
                                                shrinkWrap: true,
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                itemBuilder: (contex, index) {
                                                  return ReferenceCard(
                                                    reference: s[index],
                                                    onTap: () async {
                                                      if (s[index].type ==
                                                          'URL') {
                                                        Utils.urlLauncher(
                                                            s[index].file ??
                                                                '');
                                                      } else {
                                                        final hasPermission =
                                                            await checkAndRequestPermission();
                                                        if (hasPermission) {
                                                          BlocProvider.of<
                                                                  ReferenceCubit>(
                                                              context)
                                                            .getReferenceById(
                                                                id: state
                                                                    .references![
                                                                        index]
                                                                    .id!,
                                                                fileName: state
                                                                        .references![
                                                                            index]
                                                                        .file ??
                                                                    '');
                                                        }
                                                      }
                                                    },
                                                  );
                                                },
                                                separatorBuilder:
                                                    (context, index) {
                                                  return const SizedBox(
                                                    height: 12,
                                                  );
                                                },
                                                itemCount: s.length,
                                              ),
                                          ],
                                        );
                                      } else {
                                        return const EmptyData(
                                            title: 'No Reference Found',
                                            subtitle:
                                                'no reference data has uploaded');
                                      }
                                    } else {
                                      return const Column(
                                        children: [
                                          SizedBox(
                                            height: 24,
                                          ),
                                          CustomLoading(),
                                        ],
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class ReferenceCard extends StatefulWidget {
  final ReferenceOnListModel reference;
  final VoidCallback onTap;
  const ReferenceCard({
    required this.reference,
    super.key,
    required this.onTap,
  });

  @override
  State<ReferenceCard> createState() => _ReferenceCardState();
}

class _ReferenceCardState extends State<ReferenceCard> {
  @override
  Widget build(BuildContext context) {
    return InkWellContainer(
      radius: 12,
      onTap: widget.onTap,
      padding: const EdgeInsets.symmetric(
        vertical: 12,
        horizontal: 16,
      ),
      color: scaffoldBackgroundColor,
      boxShadow: [
        BoxShadow(
          offset: const Offset(0, 4),
          blurRadius: 24,
          spreadRadius: 0,
          color: const Color(0xFF374151).withOpacity(
            .15,
          ),
        )
      ],
      child: SizedBox(
        height: 45,
        child: Row(
          children: [
            const SizedBox(
              width: 4,
            ),
            Icon(
              widget.reference.type == 'URL'
                  ? Icons.link
                  : Icons.file_present_outlined,
              color: primaryColor,
            ),
            const SizedBox(
              width: 12,
            ),
            const VerticalDivider(),
            const SizedBox(
              width: 12,
            ),
            Expanded(
              child: Text(
                widget.reference.type == 'URL'
                    ? widget.reference.filename ??
                        widget.reference.file ??
                        'nonamed'
                    : p.basename(widget.reference.file!),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            )
          ],
        ),
      ),
    );
  }
}
