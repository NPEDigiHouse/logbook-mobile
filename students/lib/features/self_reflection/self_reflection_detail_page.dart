import 'package:common/no_internet/check_internet_onetime.dart';
import 'package:core/context/navigation_extension.dart';
import 'package:core/styles/color_palette.dart';
import 'package:core/styles/text_style.dart';
import 'package:data/models/self_reflection/student_self_reflection_model.dart';
import 'package:flutter/material.dart';
import 'package:main/widgets/dividers/section_divider.dart';

class DetailSelfReflectionPage extends StatefulWidget {
  final SelfReflectionData model;

  const DetailSelfReflectionPage({
    super.key,
    required this.model,
  });

  @override
  State<DetailSelfReflectionPage> createState() =>
      _DetailSelfReflectionPageState();
}

class _DetailSelfReflectionPageState extends State<DetailSelfReflectionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Entry Detail"),
      ).variant(),
      body: SafeArea(
        child: CheckInternetOnetime(child: (context) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
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
                      const SizedBox(
                        height: 4,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color:
                                  widget.model.verificationStatus == 'VERIFIED'
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
                                const SizedBox(
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
                      const SizedBox(
                        height: 8,
                      ),
                      const SectionDivider(),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(widget.model.content ?? ''),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
