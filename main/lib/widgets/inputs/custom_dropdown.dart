import 'package:core/styles/color_palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class CustomDropdown<T> extends StatefulWidget {
  final String hint;
  final String? init;
  final bool isRequired;
  final List<dynamic> Function(String pattern) onCallback;
  final Widget Function(dynamic suggestion) child;
  final void Function(dynamic v, TextEditingController controller) onItemSelect;
  final void Function(TextEditingController controller)? onClear;
  final ValueNotifier<String?> errorNotifier;
  final void Function(dynamic text, TextEditingController controller) onSubmit;
  const CustomDropdown({
    super.key,
    required this.hint,
    this.onClear,
    required this.onCallback,
    required this.child,
    required this.onItemSelect,
    required this.onSubmit,
    this.isRequired = true,
    required this.errorNotifier,
    this.init,
  });

  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  final TextEditingController controller = TextEditingController();
  bool isShowClear = false;
  final SuggestionsBoxController suggestionController =
      SuggestionsBoxController();
  @override
  void initState() {
    super.initState();
    if (widget.init != null) controller.text = widget.init!;
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: widget.errorNotifier,
        builder: (context, errorVal, _) {
          return TypeAheadField(
            noItemsFoundBuilder: (context) => const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 16,
              ),
              child: Text('No Items Found'),
            ),
            textFieldConfiguration: TextFieldConfiguration(
              onSubmitted: (value) => widget.onSubmit(value, controller),
              controller: controller,
              decoration: InputDecoration(
                errorText: errorVal,
                suffix: InkWell(
                  onTap: () {
                    controller.text = '';
                    widget.onClear?.call(controller);
                  },
                  child: const SizedBox(
                      width: 20,
                      height: 20,
                      child: Icon(
                        Icons.close_rounded,
                        size: 16,
                      )),
                ),
                hintText: widget.hint,
                labelText: '${widget.hint} ${widget.isRequired?"(Required)":""}',
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
        });
  }
}
