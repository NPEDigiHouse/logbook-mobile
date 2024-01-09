import 'package:core/helpers/app_size.dart';
import 'package:core/styles/color_palette.dart';
import 'package:core/styles/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:main/blocs/unit_cubit/unit_cubit.dart';
import 'package:main/widgets/custom_alert.dart';
import 'package:students/features/select_units/widgets/custom_bottom_alert.dart';

class SelectDepartmentCard extends StatelessWidget {
  const SelectDepartmentCard({
    super.key,
    required this.unitName,
    required this.unitId,
    required this.isAllow,
    required this.isDone,
    required this.activeDepartmentId,
  });

  final String unitName;
  final String unitId;
  final bool isAllow;
  final String activeDepartmentId;
  final bool isDone;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSize.getAppWidth(context),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: scaffoldBackgroundColor,
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
          ]),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 2),
              width: 5,
              decoration: BoxDecoration(
                color: isDone ? onFormDisableColor : primaryColor,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            const SizedBox(
              width: 12,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (activeDepartmentId == unitId)
                    Text(
                      "Currently selected",
                      style:
                          textTheme.labelSmall?.copyWith(color: primaryColor),
                    )
                  else if (isDone)
                    Text(
                      "Done",
                      style: textTheme.labelSmall
                          ?.copyWith(color: onFormDisableColor),
                    ),
                  if (activeDepartmentId == unitId)
                    const SizedBox(
                      height: 2,
                    ),
                  Text(
                    unitName,
                    maxLines: 2,
                    style: textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      height: 1.2,
                      color: isDone ? onFormDisableColor : primaryTextColor,
                      decoration: isDone ? TextDecoration.lineThrough : null,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 12,
            ),
            if (!isDone)
              Radio.adaptive(
                value: unitId,
                groupValue: activeDepartmentId,
                onChanged: (v) {
                  if (!isAllow) {
                    CustomAlert.error(
                        message:
                            'Cannot change department, please completed current department before!',
                        context: context);
                    // showModalBottomSheet(
                    //   context: context,
                    //   backgroundColor: Colors.white,
                    //   builder: (BuildContext context) {
                    //     return const CustomBottomAlert(
                    //       message: 'Failed to change active unit',
                    //       isFailed: true,

                    //     );
                    //   },
                    // );
                  } else {
                    final unitCubit = BlocProvider.of<DepartmentCubit>(context,
                        listen: false);
                    unitCubit.changeDepartmentActive(unitId: unitId);
                  }
                },
              ),
          ],
        ),
      ),
    );
  }
}
