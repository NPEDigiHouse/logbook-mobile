import 'package:core/context/navigation_extension.dart';
import 'package:core/helpers/asset_path.dart';
import 'package:core/styles/color_palette.dart';
import 'package:core/styles/text_style.dart';
import 'package:data/models/user/user_credential.dart';
import 'package:main/widgets/inkwell_container.dart';
import 'package:main/widgets/spacing_column.dart';

import 'supervisor_list_cst_page.dart';
import 'supervisor_list_sgl_page.dart';
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
        title: const Text("SGL and CST"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 16),
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
                  const SizedBox(
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
            offset: const Offset(0, 4),
            blurRadius: 24,
            spreadRadius: 0,
            color: const Color(0xFF374151).withOpacity(
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
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        desc,
                        style: textTheme.bodySmall?.copyWith(
                          height: 1,
                          color: secondaryTextColor,
                        ),
                      ),
                      const SizedBox(
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
