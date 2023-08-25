import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/src/data/models/self_reflection/self_reflection_post_model.dart';
import 'package:elogbook/src/presentation/blocs/self_reflection_cubit/self_reflection_cubit.dart';
import 'package:elogbook/src/presentation/widgets/spacing_column.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class AddSpecialReportPage extends StatefulWidget {
  const AddSpecialReportPage({super.key});

  @override
  State<AddSpecialReportPage> createState() => _AddSpecialReportPageState();
}

class _AddSpecialReportPageState extends State<AddSpecialReportPage> {
  final TextEditingController fieldController = new TextEditingController();
  final ValueNotifier<bool> isSaveAsDraft = ValueNotifier(false);
  @override
  Widget build(BuildContext context) {
    return BlocListener<SelfReflectionCubit, SelfReflectionState>(
      listener: (context, state) {
        if (state.isSelfReflectionPostSuccess) {
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
                  TextFormField(
                    decoration: InputDecoration(
                      label: Text('Datetime'),
                      enabled: false,
                    ),
                    initialValue: DateFormat('dd/MM/yyyy HH:mm:ss')
                        .format(DateTime.now()),
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
                      label: Text('Problems encountered, Solutions given'),
                    ),
                  ),
                  Spacer(),
                  FilledButton(
                    onPressed: () {
                      if (fieldController.text.isNotEmpty) {
                        BlocProvider.of<SelfReflectionCubit>(context)
                          ..uploadSelfReflection(
                              model: SelfReflectionPostModel(
                                  content: fieldController.text));
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
