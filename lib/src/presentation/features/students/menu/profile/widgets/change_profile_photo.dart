import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/src/presentation/blocs/profile_cubit/profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChangeProfilePhotoSheet extends StatelessWidget {
  final bool isProfilePhotoExist;
  final VoidCallback onTap;
  const ChangeProfilePhotoSheet({
    super.key,
    required this.isProfilePhotoExist,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state.removeProfileImage) {
          BlocProvider.of<ProfileCubit>(context)..getProfilePic();
          context.back();
        }
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
        decoration: const BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: onTap,
                label: Text('Change Profile Photo'),
                icon: Icon(
                  Icons.image_rounded,
                ),
              ),
            ),
            if (isProfilePhotoExist) ...[
              SizedBox(
                height: 12,
              ),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: errorColor,
                  ),
                  onPressed: () {
                    BlocProvider.of<ProfileCubit>(context)..removeProfilePic();
                  },
                  label: Text('Remove Profile Photo'),
                  icon: Icon(
                    Icons.delete,
                  ),
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
