import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/core/helpers/asset_path.dart';
import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/core/styles/text_style.dart';
import 'package:elogbook/src/data/models/user/user_credential.dart';
import 'package:elogbook/src/presentation/features/supervisor/sgl_cst/supervisor_list_cst_page.dart';
import 'package:elogbook/src/presentation/features/supervisor/sgl_cst/supervisor_list_sgl_page.dart';
import 'package:elogbook/src/presentation/widgets/inkwell_container.dart';
import 'package:elogbook/src/presentation/widgets/spacing_column.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SupervisorSglCstHomePage extends StatefulWidget {
  final UserCredential credential;
  const SupervisorSglCstHomePage({super.key, required this.credential});

  @override
  State<SupervisorSglCstHomePage> createState() =>
      _SupervisorSglCstHomePageState();
}

class _SupervisorSglCstHomePageState extends State<SupervisorSglCstHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SGL and CST"),
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
                  SglCstCard(
                    onTap: () => context.navigateTo(SupervisorListSglPage(
                      isCeu: widget.credential.badges!
                              .indexWhere((element) => element.name == 'CEU') !=
                          -1,
                      userId: widget.credential.supervisor!.supervisorId ?? '',
                    )),
                    title: 'Small Group Learning',
                    desc: 'small group learing (SGL) data',
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  SglCstCard(
                    onTap: () => context.navigateTo(SupervisorListCstPage(
                      isCeu: widget.credential.badges!
                              .indexWhere((element) => element.name == 'CEU') !=
                          -1,
                      userId: widget.credential.supervisor!.supervisorId ?? '',
                    )),
                    title: 'Clinical Skill Training',
                    desc: 'clinical skill training (CST) data',
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

class SglCstCard extends StatelessWidget {
  final String title;
  final String desc;
  final VoidCallback onTap;
  const SglCstCard({
    super.key,
    required this.desc,
    required this.onTap,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, bc) {
      return InkWellContainer(
        radius: 12,
        onTap: onTap,
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
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: SizedBox(
            width: bc.maxWidth,
            height: 132,
            child: Stack(
              children: [
                Positioned(
                  bottom: 0,
                  width: bc.maxWidth,
                  child: SpacingColumn(
                    onlyPading: true,
                    horizontalPadding: 16,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        desc,
                        style: textTheme.bodySmall?.copyWith(
                          height: 1,
                          color: secondaryTextColor,
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 0,
                  width: bc.maxWidth,
                  height: bc.maxWidth * 0.212,
                  child: SvgPicture.asset(
                    AssetPath.getIcon('sglcst_bottom.svg'),
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 0,
                  width: bc.maxWidth,
                  height: bc.maxWidth * 0.16,
                  child: SvgPicture.asset(
                    AssetPath.getIcon('sglcst_top.svg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
