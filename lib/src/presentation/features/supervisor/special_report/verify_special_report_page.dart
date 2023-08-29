import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/core/styles/text_style.dart';
import 'package:elogbook/src/data/models/special_reports/special_report_response.dart';
import 'package:elogbook/src/presentation/blocs/special_report/special_report_cubit.dart';
import 'package:elogbook/src/presentation/widgets/spacing_column.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VerifySpecialReportPage extends StatefulWidget {
  final String studentId;
  final ListProblemConsultation problemConsultation;
  const VerifySpecialReportPage(
      {super.key, required this.problemConsultation, required this.studentId});

  @override
  State<VerifySpecialReportPage> createState() =>
      _VerifySpecialReportPageState();
}

class _VerifySpecialReportPageState extends State<VerifySpecialReportPage> {
  final TextEditingController fieldController = new TextEditingController();
  final ValueNotifier<bool> isSaveAsDraft = ValueNotifier(false);
  @override
  Widget build(BuildContext context) {
    return BlocListener<SpecialReportCubit, SpecialReportState>(
      listener: (context, state) {
        if (state.isVerifySpecialReportSuccess) {
          BlocProvider.of<SpecialReportCubit>(context)
            ..getSpecialReportByStudentId(studentId: widget.studentId);
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Add Special Report"),
        ).variant(),
        body: SafeArea(
          child: CustomScrollView(slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: SpacingColumn(
                onlyPading: true,
                horizontalPadding: 16,
                children: [
                  SizedBox(
                    height: 16,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          offset: const Offset(0, 1),
                          color: Colors.black.withOpacity(.06),
                          blurRadius: 8,
                        )
                      ],
                    ),
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        dividerColor: Colors.transparent,
                      ),
                      child: ExpansionTile(
                        iconColor: primaryTextColor,
                        collapsedIconColor: primaryTextColor,
                        tilePadding: EdgeInsets.only(
                          left: 6,
                          right: 10,
                        ),
                        childrenPadding: const EdgeInsets.fromLTRB(6, 8, 6, 16),
                        title: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              'Problem',
                              style: textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 4),
                          ],
                        ),
                        expandedCrossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              widget.problemConsultation.content ?? '',
                              style: textTheme.bodyMedium,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  TextFormField(
                    minLines: 7,
                    maxLines: 7,
                    controller: fieldController,
                    textAlignVertical: TextAlignVertical.top,
                    decoration: InputDecoration(
                      label: Text('Given solution'),
                    ),
                  ),
                  Spacer(),
                  FilledButton(
                    onPressed: () {
                      if (fieldController.text.isNotEmpty) {
                        BlocProvider.of<SpecialReportCubit>(context)
                          ..verifySpecialReport(
                            solution: fieldController.text,
                            id: widget
                                .problemConsultation.problemConsultationId!,
                          );
                      }
                    },
                    child: Text('Submit'),
                  ).fullWidth(),
                  SizedBox(
                    height: 16,
                  ),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
