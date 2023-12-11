import 'package:core/context/navigation_extension.dart';
import 'package:core/styles/color_palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:main/blocs/profile_cubit/profile_cubit.dart';

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
    return BlocListener<UserCubit, UserState>(
      listener: (context, state) {
        if (state.removeProfileImage) {
          BlocProvider.of<UserCubit>(context).getProfilePic();
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
                label: const Text('Change Profile Photo'),
                icon: const Icon(
                  Icons.image_rounded,
                ),
              ),
            ),
            if (isProfilePhotoExist) ...[
              const SizedBox(
                height: 12,
              ),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: errorColor,
                  ),
                  onPressed: () {
                    BlocProvider.of<UserCubit>(context).removeProfilePic();
                  },
                  label: const Text('Remove Profile Photo'),
                  icon: const Icon(
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
