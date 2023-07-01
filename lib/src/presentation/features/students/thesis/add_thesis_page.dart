import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/src/presentation/widgets/input/build_text_field.dart';
import 'package:elogbook/src/presentation/widgets/spacing_column.dart';
import 'package:flutter/material.dart';

class AddThesisPage extends StatelessWidget {
  const AddThesisPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Thesis"),
      ).variant(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: SpacingColumn(
            spacing: 16,
            horizontalPadding: 16,
            children: [
              SizedBox(
                height: 16,
              ),
              TextFormField(
                decoration: InputDecoration(
                  label: Text('Date'),
                  enabled: false,
                ),
                initialValue: '02/20/2023 23:11:26',
              ),
              BuildTextField(
                onChanged: (v) {},
                label: 'Supervisor 1',
              ),
              BuildTextField(
                onChanged: (v) {},
                label: 'Supervisor 2',
              ),
              TextFormField(
                maxLines: 5,
                minLines: 5,
                decoration: InputDecoration(
                  label: Text('Additional Notes'),
                ),
              ),
              FilledButton(
                onPressed: () => context.back(),
                child: Text('Submit'),
              ).fullWidth(),
              SizedBox(
                height: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
