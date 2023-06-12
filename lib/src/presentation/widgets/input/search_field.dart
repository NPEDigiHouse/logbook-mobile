import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:elogbook/core/helpers/asset_path.dart';
import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/core/styles/text_style.dart';

class SearchField extends StatefulWidget {
  final String text;
  final ValueChanged<String> onChanged;

  const SearchField({
    super.key,
    required this.text,
    required this.onChanged,
  });

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: onDisableColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: _controller,
        onChanged: widget.onChanged,
        textInputAction: TextInputAction.search,
        textAlignVertical: TextAlignVertical.center,
        style: textTheme.bodyLarge?.copyWith(
          letterSpacing: 0,
          height: 1.2,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Search',
          hintStyle: textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w400,
            color: Color(0xFF6B7280),
            letterSpacing: 0,
            height: 1.2,
          ),
          prefixIcon: Padding(
            padding: const EdgeInsetsDirectional.only(
              start: 16,
              end: 12,
            ),
            child: SvgPicture.asset(
              AssetPath.getIcon('search_outlined.svg'),
            ),
          ),
          suffixIcon: widget.text.isEmpty
              ? const SizedBox()
              : IconButton(
                  icon: const Icon(
                    Icons.close,
                    color: Color(0xFF6B7280),
                    size: 16,
                  ),
                  onPressed: () {
                    _controller.clear();
                    widget.onChanged('');
                  },
                ),
        ),
      ),
    );
  }
}
