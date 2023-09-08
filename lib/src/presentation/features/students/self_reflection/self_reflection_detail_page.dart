import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/core/styles/text_style.dart';
import 'package:elogbook/src/data/models/self_reflection/student_self_reflection_model.dart';
import 'package:elogbook/src/presentation/widgets/dividers/section_divider.dart';
import 'package:flutter/material.dart';

class DetailSelfReflectionPage extends StatefulWidget {
  final SelfReflectionData model;

  const DetailSelfReflectionPage({super.key, required this.model,});

  @override
  State<DetailSelfReflectionPage> createState() =>
      _DetailSelfReflectionPageState();
}

class _DetailSelfReflectionPageState extends State<DetailSelfReflectionPage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Entry Detail"),
        actions: [
          // IconButton(
          //   onPressed: () {},
          //   icon: Icon(
          //     Icons.more_vert_rounded,
          //     color: Colors.white,
          //   ),
          // )
        ],
      ).variant(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 12,
                ),
                decoration: BoxDecoration(
                  color: scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      offset: const Offset(0, 1),
                      blurRadius: 16,
                      color: Colors.black.withOpacity(.1),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        'Self Reflection Content',
                        style: textTheme.titleMedium,
                      ),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: widget.model.verificationStatus == 'VERIFIED'
                                ? successColor
                                : errorColor,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                widget.model.verificationStatus == 'VERIFIED'
                                    ? Icons.verified_rounded
                                    : Icons.hourglass_bottom_rounded,
                                color: Colors.white,
                                size: 16,
                              ),
                              SizedBox(
                                width: 4,
                              ),
                              Text(
                                widget.model.verificationStatus ?? '',
                                style: textTheme.bodySmall?.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    SectionDivider(),
                    SizedBox(
                      height: 8,
                    ),
                    Text(widget.model.content ?? ''),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
