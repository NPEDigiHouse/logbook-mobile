import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/src/presentation/widgets/header/form_section_header.dart';
import 'package:elogbook/src/presentation/widgets/inkwell_container.dart';
import 'package:flutter/material.dart';

class CreateClinicalRecordThirdPage extends StatefulWidget {
  const CreateClinicalRecordThirdPage({super.key});

  @override
  State<CreateClinicalRecordThirdPage> createState() =>
      _CreateClinicalRecordThirdPageState();
}

class _CreateClinicalRecordThirdPageState
    extends State<CreateClinicalRecordThirdPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Clinical Record"),
      ).variant(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 4,
              ),
              FormSectionHeader(
                label: 'Attachment (Optional)',
                pathPrefix: 'icon_attachment.svg',
                padding: 16,
              ),
              InkWellContainer(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 24),
                radius: 12,
                color: Color(0xFF29C5F6).withOpacity(.2),
                margin: EdgeInsets.symmetric(horizontal: 16),
                onTap: () {},
                child: Row(
                  children: [
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: IconButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(primaryColor),
                        ),
                        padding: new EdgeInsets.all(0.0),
                        iconSize: 14,
                        onPressed: () {},
                        icon: Icon(
                          Icons.add_rounded,
                          color: backgroundColor,
                          size: 16,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text('Upload image or PDF'),
                    Spacer(),
                    Text('(max. 5 MB)')
                  ],
                ),
              ),
              SizedBox(
                height: 12,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextFormField(
                  maxLines: 5,
                  minLines: 5,
                  decoration: InputDecoration(
                    label: Text('Additional Notes'),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: FilledButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                  child: Text('Submit'),
                ).fullWidth(),
              ),
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
