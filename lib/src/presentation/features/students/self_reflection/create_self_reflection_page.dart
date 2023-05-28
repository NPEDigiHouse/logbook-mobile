import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/src/presentation/widgets/spacing_column.dart';
import 'package:flutter/material.dart';

class CreateSelfReflectionPage extends StatefulWidget {
  const CreateSelfReflectionPage({super.key});

  @override
  State<CreateSelfReflectionPage> createState() =>
      _CreateSelfReflectionPageState();
}

class _CreateSelfReflectionPageState extends State<CreateSelfReflectionPage> {
  final ValueNotifier<bool> isSaveAsDraft = ValueNotifier(false);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  onPressed: () => context.back(),
                  child: Text('Next'),
                ).fullWidth(),
                SizedBox(
                  height: 16,
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
