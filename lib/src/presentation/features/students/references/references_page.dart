import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/src/presentation/widgets/headers/unit_header.dart';
import 'package:elogbook/src/presentation/widgets/inkwell_container.dart';
import 'package:elogbook/src/presentation/widgets/inputs/search_field.dart';
import 'package:elogbook/src/presentation/widgets/spacing_column.dart';
import 'package:flutter/material.dart';

class ReferencePage extends StatelessWidget {
  const ReferencePage({super.key});

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
                  UnitHeader(),
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
                  ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (contex, index) {
                      return ReferenceCard();
                    },
                    separatorBuilder: (context, index) {
                      return SizedBox(
                        height: 12,
                      );
                    },
                    itemCount: 5,
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

class ReferenceCard extends StatelessWidget {
  const ReferenceCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWellContainer(
      radius: 12,
      onTap: () {},
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
                'List of Diseases According to SKDI 2012',
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
