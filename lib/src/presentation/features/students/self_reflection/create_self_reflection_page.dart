import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/src/data/models/self_reflection/self_reflection_post_model.dart';
import 'package:elogbook/src/presentation/blocs/self_reflection_cubit/self_reflection_cubit.dart';
import 'package:elogbook/src/presentation/widgets/spacing_column.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateSelfReflectionPage extends StatefulWidget {
  const CreateSelfReflectionPage({super.key});

  @override
  State<CreateSelfReflectionPage> createState() =>
      _CreateSelfReflectionPageState();
}

class _CreateSelfReflectionPageState extends State<CreateSelfReflectionPage> {
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
          title: Text("Self-reflection Entry"),
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
                    minLines: 7,
                    maxLines: 7,
                    controller: fieldController,
                    decoration: InputDecoration(
                      label: Text('Self-reflection Content'),
                    ),
                  ),
                  ValueListenableBuilder(
                      valueListenable: isSaveAsDraft,
                      builder: (context, val, _) {
                        return CheckboxListTile(
                          value: val,
                          onChanged: (v) {
                            isSaveAsDraft.value = !isSaveAsDraft.value;
                          },
                          title: Text('Save as Draft'),
                          controlAffinity: ListTileControlAffinity.leading,
                        );
                      }),
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
