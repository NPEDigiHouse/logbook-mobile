import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/src/presentation/widgets/dividers/section_divider.dart';
import 'package:elogbook/src/presentation/widgets/headers/form_section_header.dart';
import 'package:elogbook/src/presentation/widgets/inputs/build_text_field.dart';
import 'package:elogbook/src/presentation/widgets/spacing_column.dart';
import 'package:flutter/material.dart';

class CreateSglPage extends StatefulWidget {
  const CreateSglPage({super.key});

  @override
  State<CreateSglPage> createState() => _CreateSglPageState();
}

class _CreateSglPageState extends State<CreateSglPage> {
  List<String> items = ['Item 1', 'Item 2', 'Item 3'];
  late String selectedItem;

  @override
  void initState() {
    selectedItem = items[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add New SGL"),
      ).variant(),
      body: SafeArea(
          child: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              children: [
                FormSectionHeader(
                  label: 'General Info',
                  pathPrefix: 'icon_info.svg',
                  padding: 16,
                ),
                SpacingColumn(
                  horizontalPadding: 16,
                  spacing: 14,
                  children: [
                    BuildTextField(
                      onChanged: (v) {},
                      label: 'Date',
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search_rounded),
                        label: Text('Supervisor'),
                        suffixIcon: IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.close_rounded),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                SectionDivider(),
                FormSectionHeader(
                  label: 'Activity',
                  pathPrefix: 'icon_activity.svg',
                  padding: 16,
                ),
                SpacingColumn(
                  horizontalPadding: 16,
                  spacing: 12,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: BuildTextField(
                              onChanged: (v) {}, label: 'Start Time'),
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Expanded(
                          child: BuildTextField(
                              onChanged: (v) {}, label: 'End Time'),
                        ),
                      ],
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search_rounded),
                        label: Text('Supervisor'),
                        suffixIcon: IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.close_rounded),
                        ),
                      ),
                    ),
                    TextFormField(
                      maxLines: 4,
                      minLines: 4,
                      decoration: InputDecoration(
                        label: Text(
                          'Additional notes',
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: FilledButton(
                    onPressed: () => context.back(),
                    child: Text('Next'),
                  ).fullWidth(),
                ),
                SizedBox(
                  height: 16,
                ),
              ],
            ),
          ),
        ],
      )),
    );
  }
}
