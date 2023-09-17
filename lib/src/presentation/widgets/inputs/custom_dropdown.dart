import 'package:elogbook/core/styles/color_palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class CustomDropdown<T> extends StatefulWidget {
  final String hint;
  final String? init;
  final List<dynamic> Function(String pattern) onCallback;
  final Widget Function(dynamic suggestion) child;
  final void Function(dynamic v, TextEditingController controller) onItemSelect;
  final void Function(dynamic text, TextEditingController controller) onSubmit;
  const CustomDropdown({
    super.key,
    required this.hint,
    required this.onCallback,
    required this.child,
    required this.onItemSelect,
    required this.onSubmit,
    this.init,
  });

  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  final TextEditingController controller = TextEditingController();
  FocusNode myFocusNode = FocusNode();

  final SuggestionsBoxController suggestionController =
      SuggestionsBoxController();
  @override
  void initState() {
    super.initState();
    if (widget.init != null) controller.text = widget.init!;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TypeAheadField(
      noItemsFoundBuilder: (context) => Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 12.0,
          vertical: 16,
        ),
        child: Text('No Items Found'),
      ),
      textFieldConfiguration: TextFieldConfiguration(
        focusNode: myFocusNode,
        onSubmitted: (value) => widget.onSubmit(value, controller),
        onTapOutside: (v) {
          widget.onSubmit(controller.text, controller);
          FocusScope.of(context).unfocus();
        },
        controller: controller,
        decoration: InputDecoration(
          suffix: myFocusNode.hasFocus
              ? InkWell(
                  onTap: () {
                    controller.text = '';
                  },
                  child: SizedBox(
                      width: 20,
                      height: 20,
                      child: Icon(
                        Icons.close_rounded,
                        size: 16,
                      )),
                )
              : null,
          hintText: widget.hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(
              color: onFormDisableColor,
            ),
          ),
        ),
      ),
      suggestionsBoxController: suggestionController,
      suggestionsCallback: (pattern) => widget.onCallback(pattern),
      itemBuilder: (context, suggestion) => widget.child(suggestion),
      onSuggestionSelected: (v) => widget.onItemSelect(v, controller),
    );
  }
}
