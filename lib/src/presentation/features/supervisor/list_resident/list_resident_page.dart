import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/core/styles/text_style.dart';
import 'package:elogbook/src/presentation/features/supervisor/list_resident/resident_menu_page.dart';
import 'package:elogbook/src/presentation/widgets/inkwell_container.dart';
import 'package:elogbook/src/presentation/widgets/input/search_field.dart';
import 'package:flutter/material.dart';

class ListResidentPage extends StatelessWidget {
  const ListResidentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 16,
                ),
              ),
              SliverToBoxAdapter(
                child: Text(
                  'Unit Students',
                  style: textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
              ),
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
                itemCount: 10,
                itemBuilder: (context, index) {
                  return _buildStudentCard(context);
                },
                separatorBuilder: (context, index) {
                  return SizedBox(
                    height: 12,
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStudentCard(BuildContext context) {
    return InkWellContainer(
      color: Colors.white,
      onTap: () => context.navigateTo(ResidentMenuPage()),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
          ),
          SizedBox(
            width: 12,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Muh.Ikhsan',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: primaryTextColor,
                ),
              ),
              Text(
                'H071191049',
                style: textTheme.bodyMedium?.copyWith(
                  color: secondaryTextColor,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
