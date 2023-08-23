import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/core/styles/text_style.dart';
import 'package:elogbook/src/presentation/features/students/menu/history/history_data.dart';
import 'package:elogbook/src/presentation/widgets/inputs/search_field.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grouped_list/sliver_grouped_list.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({super.key});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  late ValueNotifier<String> _selectedMenu;

  final _menuList = [
    'All',
    'Clinical Record',
    'Scientific Session',
    'Self Reflection',
    'Daily Activity',
  ];

  @override
  void initState() {
    super.initState();
    _selectedMenu = ValueNotifier(_menuList[0]);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _selectedMenu.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: SizedBox(
                height: 12,
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverToBoxAdapter(
                child: Text(
                  'Tasks',
                  style: textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 12,
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverToBoxAdapter(
                child: SearchField(
                  onChanged: (value) {},
                  text: 'Search',
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 4,
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 64,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  scrollDirection: Axis.horizontal,
                  itemCount: _menuList.length,
                  itemBuilder: (context, index) {
                    return ValueListenableBuilder(
                      valueListenable: _selectedMenu,
                      builder: (context, value, child) {
                        final selected = value == _menuList[index];

                        return RawChip(
                          pressElevation: 0,
                          clipBehavior: Clip.antiAlias,
                          label: Text(_menuList[index]),
                          labelPadding: const EdgeInsets.symmetric(
                            horizontal: 6,
                          ),
                          labelStyle: textTheme.bodyMedium?.copyWith(
                            color: selected ? primaryColor : primaryTextColor,
                          ),
                          side: BorderSide(
                            color: selected ? Colors.transparent : borderColor,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          checkmarkColor: primaryColor,
                          selectedColor: primaryColor.withOpacity(.2),
                          selected: selected,
                          onSelected: (_) {
                            _selectedMenu.value = _menuList[index];
                          },
                        );
                      },
                    );
                  },
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                ),
              ),
            ),
            SliverGroupedListView<Activity, DateTime>(
              elements: activities,
              groupBy: (activity) => activity.date,
              groupComparator: (date1, date2) => date1.compareTo(date2) * -1,
              itemBuilder: (context, activity) {
                return Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 20,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              width: 68,
                              height: 68,
                              color: primaryColor.withOpacity(.1),
                              child: Center(
                                child: SvgPicture.asset(
                                  activity.iconPath,
                                  color: primaryColor,
                                  width: 32,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Text(
                                      activity.title,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: textTheme.titleSmall?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    if (activity.isVerified)
                                      const Icon(
                                        Icons.verified_rounded,
                                        size: 16,
                                        color: primaryColor,
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                RichText(
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  text: TextSpan(
                                    style: textTheme.bodySmall?.copyWith(
                                      color: secondaryTextColor,
                                    ),
                                    children: <TextSpan>[
                                      const TextSpan(
                                        text: 'Supervisor:\t',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      TextSpan(text: activity.supervisor),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 4),
                                RichText(
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  text: TextSpan(
                                    style: textTheme.bodySmall?.copyWith(
                                      color: secondaryTextColor,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: activity is ScientificSession
                                            ? 'Session:\t'
                                            : 'Patient:\t',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      TextSpan(
                                        text: activity is ScientificSession
                                            ? activity.sessionType
                                            : (activity as ClinicalRecord)
                                                .patient,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                if (activity is ClinicalRecord)
                                  if (activity.hasAttachment)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 4,
                                        horizontal: 12,
                                      ),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: dividerColor),
                                        borderRadius: BorderRadius.circular(99),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          const Icon(
                                            Icons.attachment_rounded,
                                            size: 14,
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            'attachment_file.pdf',
                                            style:
                                                textTheme.labelSmall?.copyWith(
                                              fontWeight: FontWeight.w500,
                                              letterSpacing: 0,
                                              height: 0,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              groupSeparatorBuilder: (date) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Divider(
                      height: 6,
                      thickness: 6,
                      color: onDisableColor,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                      child: Text(
                        timeago.format(date),
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                );
              },
              separator: const Divider(
                height: 1,
                thickness: 1,
                indent: 20,
                endIndent: 20,
                color: Color(0xFFEFF0F9),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
