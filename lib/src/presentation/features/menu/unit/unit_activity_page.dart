import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:elogbook/core/helpers/app_size.dart';
import 'package:elogbook/core/helpers/asset_path.dart';
import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/core/styles/text_style.dart';
import 'package:elogbook/src/presentation/widgets/glassmorphism.dart';
import 'package:elogbook/src/presentation/widgets/main_app_bar.dart';
import 'package:elogbook/src/presentation/widgets/menu/report_expansion_tile.dart';

class UnitActivityPage extends StatelessWidget {
  const UnitActivityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 24,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Unit Activity',
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 32,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'Lorem ipsum dolor sit amet consectetur',
              style: textTheme.bodySmall?.copyWith(
                color: secondaryTextColor,
                letterSpacing: 0,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: AppSize.getAppWidth(context) - 46,
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    offset: const Offset(6, 8),
                    color: primaryColor.withOpacity(.3),
                  ),
                ],
              ),
              child: Stack(
                children: <Widget>[
                  Positioned(
                    left: 0,
                    bottom: 0,
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(16),
                      ),
                      child: SvgPicture.asset(
                        AssetPath.getVector('ellipse_1.svg'),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: SvgPicture.asset(
                      AssetPath.getVector('half_ellipse.svg'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Current Unit',
                          style: TextStyle(color: backgroundColor),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Obstetrics and Gynecology',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                            color: backgroundColor,
                          ),
                        ),
                        const SizedBox(height: 16),
                        InkWell(
                          onTap: () {},
                          child: Glassmorphism(
                            blur: 5,
                            opacity: .15,
                            radius: 99,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Icon(
                                    Icons.change_circle_outlined,
                                    size: 20,
                                    color: backgroundColor,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    'Change Unit',
                                    style: textTheme.labelLarge?.copyWith(
                                      color: backgroundColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            ReportExpansionTile(
              isVerified: true,
              leadingIcon: Icons.arrow_upward_rounded,
              leadingColor: variant2Color,
              title: 'Check In',
              subtitle: '12 Jun 2023, 01:50 pm',
              children: <Widget>[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: onDisableColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Status',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(99),
                          color: successColor.withOpacity(.25),
                        ),
                        child: Text(
                          'Terverifikasi',
                          style: textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: successColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Report time',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '12 Jun 2023, 01:50 pm',
                        style: textTheme.bodySmall?.copyWith(
                          color: secondaryTextColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ReportExpansionTile(
              leadingIcon: Icons.arrow_downward_rounded,
              leadingColor: successColor,
              title: 'Check Out',
              subtitle: 'Not Submitted yet',
              children: <Widget>[
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () {},
                    icon: SvgPicture.asset(
                      AssetPath.getIcon('send_alt_filled.svg'),
                      width: 20,
                    ),
                    label: Text('Send Report'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
