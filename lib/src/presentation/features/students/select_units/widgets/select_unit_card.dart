import 'package:elogbook/core/helpers/app_size.dart';
import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/core/styles/text_style.dart';
import 'package:elogbook/src/presentation/blocs/unit_cubit/unit_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SelectDepartmentCard extends StatelessWidget {
  const SelectDepartmentCard({
    super.key,
    required this.unitName,
    required this.unitId,
    required this.activeDepartmentId,
  });

  final String unitName;
  final String unitId;
  final String activeDepartmentId;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSize.getAppWidth(context),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
                offset: Offset(0, 0),
                spreadRadius: 0,
                blurRadius: 6,
                color: Color(0xFFD4D4D4).withOpacity(.25)),
            BoxShadow(
                offset: Offset(0, 4),
                spreadRadius: 0,
                blurRadius: 24,
                color: Color(0xFFD4D4D4).withOpacity(.25)),
          ]),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 2),
              width: 5,
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            SizedBox(
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
                    ),
                  if (activeDepartmentId == unitId)
                    SizedBox(
                      height: 2,
                    ),
                  Text(
                    unitName,
                    maxLines: 2,
                    style: textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 12,
            ),
            Radio.adaptive(
              value: unitId,
              groupValue: activeDepartmentId,
              onChanged: (v) {
                final unitCubit =
                    BlocProvider.of<DepartmentCubit>(context, listen: false);
                unitCubit.changeDepartmentActive(unitId: unitId);
              },
            ),
          ],
        ),
      ),
    );
  }
}
