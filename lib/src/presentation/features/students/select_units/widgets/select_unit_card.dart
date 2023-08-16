import 'package:elogbook/core/helpers/app_size.dart';
import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/core/styles/text_style.dart';
import 'package:elogbook/src/presentation/blocs/unit_cubit/unit_cubit.dart';
import 'package:elogbook/src/presentation/features/students/select_units/widgets/custom_bottom_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SelectUnitCard extends StatelessWidget {
  const SelectUnitCard({
    super.key,
    required this.unitName,
    required this.unitId,
    required this.activeUnitId,
  });

  final String unitName;
  final String unitId;
  final String activeUnitId;

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
                  if (activeUnitId == unitId)
                    Text(
                      "Currently selected",
                      style:
                          textTheme.labelSmall?.copyWith(color: primaryColor),
                    ),
                  if (activeUnitId == unitId)
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
              groupValue: activeUnitId,
              onChanged: (v) {
                final unitCubit =
                    BlocProvider.of<UnitCubit>(context, listen: false);
                unitCubit.changeUnitActive(unitId: unitId);
              },
            ),
          ],
        ),
      ),
    );
  }
}
