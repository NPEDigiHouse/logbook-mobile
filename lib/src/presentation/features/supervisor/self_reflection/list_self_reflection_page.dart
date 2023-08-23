import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/core/helpers/asset_path.dart';
import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/core/styles/text_style.dart';
import 'package:elogbook/src/presentation/blocs/scientific_session_supervisor_cubit/scientific_session_supervisor_cubit.dart';
import 'package:elogbook/src/presentation/blocs/self_reflection_supervisor_cubit/self_reflection_supervisor_cubit.dart';
import 'package:elogbook/src/presentation/features/supervisor/list_resident/list_resident_page.dart';
import 'package:elogbook/src/presentation/features/supervisor/list_resident/resident_menu_page.dart';
import 'package:elogbook/src/presentation/features/supervisor/scientific_session/scientific_session_card.dart';
import 'package:elogbook/src/presentation/features/supervisor/self_reflection/self_reflection_card.dart';
import 'package:elogbook/src/presentation/widgets/inkwell_container.dart';
import 'package:elogbook/src/presentation/widgets/inputs/search_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ListSelfReflectionsPage extends StatefulWidget {
  const ListSelfReflectionsPage({super.key});

  @override
  State<ListSelfReflectionsPage> createState() =>
      _ListSelfReflectionsPageState();
}

class _ListSelfReflectionsPageState extends State<ListSelfReflectionsPage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<SelfReflectionSupervisorCubit>(context)
      ..getSelfReflections();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scientific Session'),
      ).variant(),
      body: SafeArea(
        child: BlocBuilder<SelfReflectionSupervisorCubit,
            SelfReflectionSupervisorState>(
          builder: (context, state) {
            if (state.listData == null) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 16,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: SearchField(
                      onChanged: (value) {},
                      text: 'Search',
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 16,
                    ),
                  ),
                  SliverList.separated(
                    itemCount: state.listData!.length,
                    itemBuilder: (context, index) {
                      return SelfReflectionCard(
                        selfReflection: state.listData![index],
                      );
                    },
                    separatorBuilder: (context, index) {
                      return SizedBox(
                        height: 12,
                      );
                    },
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
