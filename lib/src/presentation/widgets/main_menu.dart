import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:elogbook/core/helpers/app_size.dart';
import 'package:elogbook/core/helpers/asset_path.dart';
import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/core/styles/text_style.dart';
import 'package:elogbook/src/presentation/blocs/auth_cubit/auth_cubit.dart';
import 'package:elogbook/src/presentation/widgets/inkwell_container.dart';

class MainMenu extends StatelessWidget {
  final String username;
  final String role;
  final List<MenuItem> menuItems;

  const MainMenu({
    super.key,
    required this.username,
    required this.role,
    required this.menuItems,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        shadowColor: Colors.transparent,
        backgroundColor: scaffoldBackgroundColor,
        surfaceTintColor: scaffoldBackgroundColor,
        title: const Text('E-Logbook'),
        centerTitle: false,
        titleTextStyle: textTheme.titleMedium?.copyWith(
          color: primaryColor,
          fontWeight: FontWeight.w700,
          fontSize: 18,
        ),
        leading: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: SvgPicture.asset(
            AssetPath.getVector('logo.svg'),
          ),
        ),
        leadingWidth: 56,
      ),
      body: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: AppSize.getAppHeight(context),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 24,
                ),
                decoration: BoxDecoration(
                  color: scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      offset: const Offset(0, 1),
                      color: Colors.black.withOpacity(.1),
                      blurRadius: 12,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            username,
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            role,
                            style: textTheme.bodySmall?.copyWith(
                              color: primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 24),
                    IconButton.outlined(
                      icon: const Icon(Icons.logout_rounded),
                      iconSize: 20,
                      color: primaryColor,
                      tooltip: 'Logout',
                      onPressed: () async {
                        await BlocProvider.of<AuthCubit>(context).logout();
                      },
                      style: IconButton.styleFrom(
                        side: const BorderSide(color: primaryColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              GridView(
                padding: const EdgeInsets.all(0),
                primary: false,
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 24,
                  crossAxisSpacing: 16,
                ),
                children: menuItems,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MenuItem extends StatelessWidget {
  final String name;
  final String iconPath;
  final VoidCallback onTap;
  final bool isVerification;

  const MenuItem({
    super.key,
    required this.name,
    required this.iconPath,
    required this.onTap,
    this.isVerification = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWellContainer(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(
        vertical: 20,
        horizontal: 16,
      ),
      radius: 12,
      color: scaffoldBackgroundColor,
      boxShadow: <BoxShadow>[
        BoxShadow(
          offset: const Offset(0, 1),
          color: Colors.black.withOpacity(.08),
          blurRadius: 8,
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: primaryColor,
            ),
            child: SvgPicture.asset(
              AssetPath.getIcon(iconPath),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            isVerification ? 'Verification' : 'Input Score',
            style: textTheme.bodySmall?.copyWith(
              color: const Color(0xFF848FA9),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
