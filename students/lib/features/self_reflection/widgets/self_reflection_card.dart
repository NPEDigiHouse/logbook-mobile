import 'package:core/context/navigation_extension.dart';
import 'package:core/helpers/utils.dart';
import 'package:core/styles/color_palette.dart';
import 'package:core/styles/text_style.dart';
import 'package:data/models/self_reflection/student_self_reflection_model.dart';
import 'package:data/models/user/user_credential.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:main/blocs/self_reflection_cubit/self_reflection_cubit.dart';
import 'package:main/widgets/verify_dialog.dart';
import 'package:students/features/self_reflection/create_self_reflection_page.dart';

class StudentSelfReflectionCard extends StatelessWidget {
  final UserCredential? credential;
  final bool isFromNotif;

  const StudentSelfReflectionCard({
    super.key,
    this.credential,
    required this.model,
    this.isFromNotif = false,
  });

  final SelfReflectionData model;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              offset: const Offset(0, 0),
              spreadRadius: 0,
              blurRadius: 6,
              color: const Color(0xFFD4D4D4).withOpacity(.25)),
          BoxShadow(
              offset: const Offset(0, 4),
              spreadRadius: 0,
              blurRadius: 24,
              color: const Color(0xFFD4D4D4).withOpacity(.25)),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Self Reflections',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.titleSmall?.copyWith(),
                  ),
                  Text(
                    Utils.datetimeToString(
                      DateTime.fromMillisecondsSinceEpoch(
                        model.updatedAt ?? 0,
                      ),
                    ),
                    style: textTheme.bodyMedium?.copyWith(
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                      height: 1,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: model.verificationStatus == 'VERIFIED'
                              ? successColor
                              : onFormDisableColor,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              model.verificationStatus == 'VERIFIED'
                                  ? Icons.verified_rounded
                                  : Icons.hourglass_bottom_rounded,
                              color: Colors.white,
                              size: 16,
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            Text(
                              model.verificationStatus ?? '',
                              style: textTheme.bodySmall?.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              if (model.verificationStatus != 'VERIFIED')
                PopupMenuButton<String>(
                  icon: const Icon(
                    Icons.more_vert_rounded,
                  ),
                  onSelected: (value) {
                    if (value == 'Edit') {
                      context.navigateTo(
                        CreateSelfReflectionPage(
                          credential: credential,
                          id: model.selfReflectionId!,
                          content: model.content,
                          isFromNotif: isFromNotif,
                        ),
                      );
                      // context.read<SelfReflectionCubit>().updateSelfReflection(id: model.selfReflectionId!, content: model.content??'')
                    }

                    if (value == 'Delete') {
                      showDialog(
                        context: context,
                        barrierLabel: '',
                        barrierDismissible: false,
                        builder: (_) => VerifyDialog(
                          onTap: () {
                            BlocProvider.of<SelfReflectionCubit>(context)
                                .deleteSelfReflection(
                                    id: model.selfReflectionId!);

                            Navigator.pop(context);
                          },
                        ),
                      );
                    }
                  },
                  itemBuilder: (BuildContext context) {
                    return <PopupMenuEntry<String>>[
                      const PopupMenuItem<String>(
                        value: 'Edit',
                        child: Text('Edit'),
                      ),
                      const PopupMenuItem<String>(
                        value: 'Delete',
                        child: Text('Delete'),
                      ),
                    ];
                  },
                ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: onFormDisableColor.withOpacity(.2),
            ),
            child: ExpandableText(
              model.content ?? '-',
              style: textTheme.bodyMedium?.copyWith(
                color: primaryTextColor,
                height: 1.2,
              ),
              linkStyle: textTheme.bodyMedium?.copyWith(
                color: onFormDisableColor,
                height: 1.2,
              ),
              expandText: 'more',
              collapseText: 'less',
              maxLines: 3,
            ),
          ),
        ],
      ),
    );
  }
}
