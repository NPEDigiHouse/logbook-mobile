import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grouped_list/sliver_grouped_list.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/core/helpers/asset_path.dart';
import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/core/styles/text_style.dart';
import 'package:elogbook/src/presentation/features/students/clinical_record/pages/detail_clinical_record_page.dart';
import 'package:elogbook/src/presentation/features/students/menu/history/history_data.dart';
import 'package:elogbook/src/presentation/features/students/menu/history/history_filter_bottom_sheet.dart';
import 'package:elogbook/src/presentation/features/students/scientific_session/detail_scientific_session_page.dart';
import 'package:elogbook/src/presentation/widgets/input/search_field.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late final List<String> _menuList;

  late final ValueNotifier<String> _query, _selectedMenu;
  late final ValueNotifier<Map<String, String>?> _dataFilters;

  @override
  void initState() {
    _menuList = [
      'All',
      'Clinical Record',
      'Scientific Session',
      'Self Reflection',
      'Daily Activity',
    ];

    _query = ValueNotifier('');
    _selectedMenu = ValueNotifier(_menuList[0]);
    _dataFilters = ValueNotifier(null);

    super.initState();
  }

  @override
  void dispose() {
    _query.dispose();
    _selectedMenu.dispose();
    _dataFilters.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      floatHeaderSlivers: true,
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return <Widget>[
          SliverAppBar(
            floating: true,
            automaticallyImplyLeading: false,
            toolbarHeight: kToolbarHeight + 140,
            backgroundColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarIconBrightness: Brightness.dark,
            ),
            flexibleSpace: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                buildTitleSection(),
                buildSearchFilterSection(),
              ],
            ),
          ),
        ];
      },
      body: CustomScrollView(
        slivers: <Widget>[
          SliverGroupedListView<Activity, DateTime>(
            elements: activities,
            groupBy: (activity) => activity.date,
            groupComparator: (date1, date2) => date1.compareTo(date2) * -1,
            itemBuilder: (context, activity) {
              return Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: activity is ClinicalRecord
                      ? () => context.navigateTo(
                            const DetailClinicalRecordPage(),
                          )
                      : () => context.navigateTo(
                            const DetailScientificSessionPage(),
                          ),
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
                                          style: textTheme.labelSmall?.copyWith(
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
    );
  }

  Stack buildTitleSection() {
    return Stack(
      children: <Widget>[
        Positioned(
          right: 16,
          top: 0,
          child: SvgPicture.asset(
            AssetPath.getVector('circle_bg2.svg'),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 32, 8, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'History',
                style: textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: primaryColor,
                ),
              ),
              IconButton(
                onPressed: () async {
                  final data = await showModalBottomSheet<Map<String, String>?>(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) => const HistoryFilterBottomSheet(),
                  );

                  if (data != null) _dataFilters.value = data;
                },
                icon: const Icon(
                  Icons.filter_list_rounded,
                  color: primaryColor,
                ),
                tooltip: 'Filter',
              ),
            ],
          ),
        ),
      ],
    );
  }

  ValueListenableBuilder<Map<String, String>?> buildSearchFilterSection() {
    return ValueListenableBuilder(
      valueListenable: _dataFilters,
      builder: (context, data, value) {
        return Column(
          children: <Widget>[
            if (data != null) ...[
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    RichText(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                        style: textTheme.labelSmall,
                        children: <TextSpan>[
                          const TextSpan(text: 'From\t'),
                          TextSpan(
                            text: data['start_date'],
                            style: textTheme.bodyLarge?.copyWith(
                              color: primaryColor,
                            ),
                          ),
                          const TextSpan(text: '\tto\t'),
                          TextSpan(
                            text: data['end_date'],
                            style: textTheme.bodyLarge?.copyWith(
                              color: primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    RichText(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                        style: textTheme.labelSmall,
                        children: <TextSpan>[
                          const TextSpan(text: 'Activity\t'),
                          TextSpan(
                            text: data['activity']!.toCapitalize(),
                            style: textTheme.bodyLarge?.copyWith(
                              color: primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    RichText(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                        style: textTheme.labelSmall,
                        children: <TextSpan>[
                          const TextSpan(text: 'Status\t'),
                          TextSpan(
                            text: data['status']!.toCapitalize(),
                            style: textTheme.bodyLarge?.copyWith(
                              color: primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () => _dataFilters.value = null,
                        child: const Text(
                          'Reset filter',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ] else ...[
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 20,
                ),
                child: ValueListenableBuilder(
                  valueListenable: _query,
                  builder: (context, query, child) {
                    return SearchField(
                      text: query,
                      onChanged: (value) => _query.value = value,
                    );
                  },
                ),
              ),
              SizedBox(
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
                        final left = selected ? 4.0 : 12.0;

                        return RawChip(
                          pressElevation: 0,
                          clipBehavior: Clip.antiAlias,
                          label: Text(_menuList[index]),
                          labelPadding: EdgeInsets.fromLTRB(left, 0, 12, 0),
                          labelStyle: textTheme.bodyMedium?.copyWith(
                            color: selected ? primaryColor : primaryTextColor,
                          ),
                          side: selected
                              ? const BorderSide(color: Colors.transparent)
                              : const BorderSide(color: Color(0xFF8E90A3)),
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
            ],
          ],
        );
      },
    );
  }
}