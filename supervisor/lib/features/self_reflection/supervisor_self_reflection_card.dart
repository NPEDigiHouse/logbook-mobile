import 'package:core/helpers/utils.dart';
import 'package:core/styles/color_palette.dart';
import 'package:core/styles/text_style.dart';
import 'package:data/models/self_reflection/student_self_reflection2_model.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:main/blocs/clinical_record_cubit/clinical_record_cubit.dart';
import 'package:main/blocs/self_reflection_supervisor_cubit/self_reflection_supervisor_cubit.dart';

import 'widgets/verify_dialog.dart';
import 'package:flutter/material.dart';

class SupervisorSelfReflectionCard extends StatelessWidget {
  final SelfReflectionData2 data;
  const SupervisorSelfReflectionCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
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
                    Utils.epochToStringDate(
                      startTime: (data.updatedAt ?? 0) ~/ 1000,
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
                          color: data.verificationStatus == 'VERIFIED'
                              ? successColor
                              : onFormDisableColor,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              data.verificationStatus == 'VERIFIED'
                                  ? Icons.verified_rounded
                                  : Icons.hourglass_bottom_rounded,
                              color: Colors.white,
                              size: 16,
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            Text(
                              data.verificationStatus ?? '',
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
              data.content ?? '-',
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
          const SizedBox(
            height: 8,
          ),
          if (data.verificationStatus != 'VERIFIED')
            Align(
              alignment: Alignment.centerRight,
              child: BlocSelector<SelfReflectionSupervisorCubit,
                  SelfReflectionSupervisorState, bool>(
                selector: (state) => state.detailState == RequestState.loading,
                builder: (context, isLoading) {
                  return FilledButton(
                    onPressed: isLoading
                        ? null
                        : () => showDialog(
                            context: context,
                            barrierLabel: '',
                            barrierDismissible: false,
                            builder: (_) => VerifySelfReflectionDialog(
                                  id: data.selfReflectionId!,
                                )).then((value) {}),
                    child: const Text('Verify'),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
