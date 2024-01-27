import 'package:core/context/navigation_extension.dart';
import 'package:core/styles/color_palette.dart';
import 'package:core/styles/text_style.dart';
import 'package:data/models/supervisors/student_unit_model.dart';
import 'package:main/blocs/supervisor_cubit/supervisors_cubit.dart';
import 'package:main/widgets/custom_shimmer.dart';
import 'package:main/widgets/profile_pic_placeholder.dart';

import '../supervisor_final_grade_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudentDepartmentCard extends StatelessWidget {
  final StudentDepartmentModel data;
  const StudentDepartmentCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          context.navigateTo(SupervisorFinalGrade(
            studentId: data.studentId ?? '',
            studentName: data.studentName ?? '',
            departmentId: data.activeDepartmentId ?? '',
            departmentName: data.activeDepartmentName ?? '',
          ));
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 12,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              FutureBuilder(
                future: BlocProvider.of<SupervisorsCubit>(context)
                    .getImageProfile(id: data.userId ?? ''),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CustomShimmer(
                        child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      width: 50,
                      height: 50,
                    ));
                  } else if (snapshot.hasData) {
                    data.profileImage = snapshot.data;
                    return CircleAvatar(
                      radius: 25,
                      foregroundImage: MemoryImage(snapshot.data!),
                    );
                  } else {
                    return ProfilePicPlaceholder(
                        height: 50,
                        name: data.studentName ?? '-',
                        width: 50,
                        isSmall: true);
                  }
                },
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      data.studentId ?? '-',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      data.studentName ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    RichText(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                        style: textTheme.bodySmall?.copyWith(
                          color: secondaryTextColor,
                        ),
                        children: <TextSpan>[
                          const TextSpan(
                            text: 'Active Department:\t',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          TextSpan(
                            text: data.activeDepartmentName ??
                                'No Active Department',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
