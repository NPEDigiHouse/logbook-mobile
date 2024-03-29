import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/core/styles/text_style.dart';
import 'package:elogbook/src/presentation/blocs/assesment_cubit/assesment_cubit.dart';
import 'package:elogbook/src/presentation/features/supervisor/assesment/pages/supervisor_mini_cex_detail_page.dart';
import 'package:elogbook/src/presentation/widgets/custom_loading.dart';
import 'package:elogbook/src/presentation/widgets/empty_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ListMiniCexPage extends StatefulWidget {
  final String studentId;
  final String unitName;
  final String supervisorId;
  const ListMiniCexPage(
      {super.key,
      required this.unitName,
      required this.studentId,
      required this.supervisorId});

  @override
  State<ListMiniCexPage> createState() => _ListMiniCexPageState();
}

class _ListMiniCexPageState extends State<ListMiniCexPage> {
  @override
  void initState() {
    BlocProvider.of<AssesmentCubit>(context)
      ..studentMiniCex(studentId: widget.studentId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mini Cex"),
      ).variant(),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.wait([
            BlocProvider.of<AssesmentCubit>(context)
                .studentMiniCex(studentId: widget.studentId),
          ]);
        },
        child: BlocConsumer<AssesmentCubit, AssesmentState>(
          listener: (context, state) {
            if (state.studentMiniCex != null &&
                state.studentMiniCex!.id != null) {
              context.replace(SupervisorMiniCexDetailPage(
                  unitName: widget.unitName,
                  id: state.studentMiniCex!.id!,
                  supervisorId: widget.supervisorId));
            }
          },
          builder: (context, state) {
            if (state.studentMiniCex != null &&
                state.studentMiniCex!.id == null) {
              return EmptyData(
                title: 'Mini Cex Data Still Empty',
                subtitle: 'student have not yet upload mini cex data',
              );
            }
            return CustomLoading();
          },
        ),
      ),
    );
  }
}

class TitleAssesmentCard extends StatelessWidget {
  final String title;
  final String subtitle;
  const TitleAssesmentCard({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          colors: [
            primaryColor,
            secondaryColor,
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Exam Case Title",
            style: textTheme.titleMedium?.copyWith(
              color: scaffoldBackgroundColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "\"${title}\"",
            style: textTheme.bodyLarge?.copyWith(
              color: scaffoldBackgroundColor,
            ),
          ),
          SizedBox(
            height: 4,
          ),
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: Colors.white.withOpacity(.75),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 16,
                      color: primaryColor,
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Text(
                      "${subtitle}",
                      style: textTheme.bodyMedium?.copyWith(
                        color: primaryTextColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
