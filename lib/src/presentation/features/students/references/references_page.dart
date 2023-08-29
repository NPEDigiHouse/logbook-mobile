import 'dart:io';
import 'dart:typed_data';

import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/src/data/models/reference/reference_on_list_model.dart';
import 'package:elogbook/src/data/models/units/active_unit_model.dart';
import 'package:elogbook/src/presentation/blocs/reference/reference_cubit.dart';
import 'package:elogbook/src/presentation/widgets/empty_data.dart';
import 'package:elogbook/src/presentation/widgets/headers/unit_header.dart';
import 'package:elogbook/src/presentation/widgets/inkwell_container.dart';
import 'package:elogbook/src/presentation/widgets/inputs/search_field.dart';
import 'package:elogbook/src/presentation/widgets/spacing_column.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart' as p;
import 'package:document_file_save_plus/document_file_save_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class ReferencePage extends StatefulWidget {
  final ActiveUnitModel activeUnitModel;

  const ReferencePage({super.key, required this.activeUnitModel});

  @override
  State<ReferencePage> createState() => _ReferencePageState();
}

class _ReferencePageState extends State<ReferencePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<ReferenceCubit>(context)
      ..getListReference(unitId: widget.activeUnitModel.unitId!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("References"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: SpacingColumn(
            onlyPading: true,
            horizontalPadding: 16,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  UnitHeader(
                    unitName: widget.activeUnitModel.unitName!,
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  SearchField(
                    onChanged: (String value) {},
                    text: 'Search',
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  BlocConsumer<ReferenceCubit, ReferenceState>(
                    listener: (context, state) {
                      if (state.isSuccessDownload) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Success download data')),
                        );
                      }
                    },
                    builder: (context, state) {
                      if (state.references != null) {
                        if (state.references!.isNotEmpty)
                          return ListView.separated(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (contex, index) {
                              return ReferenceCard(
                                reference: state.references![index],
                                onTap: () {
                                  BlocProvider.of<ReferenceCubit>(context)
                                    ..getReferenceById(
                                        id: state.references![index].id!,
                                        fileName:
                                            state.references![index].file ??
                                                '');
                                },
                              );
                            },
                            separatorBuilder: (context, index) {
                              return SizedBox(
                                height: 12,
                              );
                            },
                            itemCount: state.references!.length,
                          );
                        else
                          return EmptyData(
                              title: 'No Reference Found',
                              subtitle: 'no reference data has uploaded');
                      } else
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class ReferenceCard extends StatefulWidget {
  final ReferenceOnListModel reference;
  final VoidCallback onTap;
  ReferenceCard({
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
      padding: EdgeInsets.symmetric(
        vertical: 12,
        horizontal: 16,
      ),
      color: scaffoldBackgroundColor,
      boxShadow: [
        BoxShadow(
          offset: Offset(0, 4),
          blurRadius: 24,
          spreadRadius: 0,
          color: Color(0xFF374151).withOpacity(
            .15,
          ),
        )
      ],
      child: SizedBox(
        height: 45,
        child: Row(
          children: [
            SizedBox(
              width: 4,
            ),
            Icon(
              Icons.file_present_outlined,
              color: primaryColor,
            ),
            SizedBox(
              width: 12,
            ),
            VerticalDivider(),
            SizedBox(
              width: 12,
            ),
            Expanded(
              child: Text(
                p.basename(widget.reference.file!),
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
