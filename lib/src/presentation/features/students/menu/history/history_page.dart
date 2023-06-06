import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:elogbook/core/helpers/asset_path.dart';
import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/core/styles/text_style.dart';
import 'package:elogbook/src/presentation/widgets/input/search_field.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late final List<String> _menuList;
  late final ValueNotifier<String> _query, _selectedMenu;

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

    super.initState();
  }

  @override
  void dispose() {
    _query.dispose();
    _selectedMenu.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return <Widget>[
            SliverToBoxAdapter(
              child: Stack(
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
                          onPressed: () {},
                          icon: Icon(
                            Icons.filter_list_rounded,
                            color: primaryColor,
                          ),
                          tooltip: 'Filter',
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            SliverAppBar(
              elevation: 0,
              floating: true,
              automaticallyImplyLeading: false,
              toolbarHeight: kToolbarHeight + 75,
              backgroundColor: Colors.transparent,
              surfaceTintColor: Colors.transparent,
              flexibleSpace: SizedBox(
                child: Column(
                  children: <Widget>[
                    buildSearchField(),
                    buildChoiceChips(),
                  ],
                ),
              ),
            ),
          ];
        },
        body: Placeholder(),
      ),
    );
  }

  Padding buildSearchField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 6),
      child: ValueListenableBuilder(
        valueListenable: _query,
        builder: (context, query, child) {
          return SearchField(
            text: query,
            onChanged: (value) => _query.value = value,
          );
        },
      ),
    );
  }

  SizedBox buildChoiceChips() {
    return SizedBox(
      height: 64,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
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
                labelPadding: EdgeInsets.fromLTRB(selected ? 4 : 12, 0, 12, 0),
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
                backgroundColor: scaffoldBackgroundColor,
                selectedColor: primaryColor.withOpacity(.2),
                selected: selected,
                onSelected: (_) => _selectedMenu.value = _menuList[index],
              );
            },
          );
        },
        separatorBuilder: (_, __) => const SizedBox(width: 8),
      ),
    );
  }
}
