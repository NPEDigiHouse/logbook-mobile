import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:elogbook/core/styles/color_palette.dart';

class ExportDataPage extends StatefulWidget {
  const ExportDataPage({super.key});

  @override
  State<ExportDataPage> createState() => _ExportDataPageState();
}

class _ExportDataPageState extends State<ExportDataPage> {
  late final List<String> _exportTypes;

  late final ValueNotifier<bool> _isSpesificUnit;
  late final ValueNotifier<Map<String, dynamic>> _formNotifier;

  @override
  void initState() {
    _exportTypes = [
      'PDF Report',
      'Attachments',
    ];

    _isSpesificUnit = ValueNotifier(false);

    _formNotifier = ValueNotifier({
      'export_type': _exportTypes[0],
      'is_spesific_unit': _isSpesificUnit.value,
    });

    super.initState();
  }

  @override
  void dispose() {
    _isSpesificUnit.dispose();
    _formNotifier.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Export Data'),
        backgroundColor: scaffoldBackgroundColor.withAlpha(200),
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(color: Colors.transparent),
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 24,
                horizontal: 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    'Export Type',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField(
                    value: _exportTypes.first,
                    items: _exportTypes.map((e) {
                      return DropdownMenuItem(
                        value: e,
                        child: Text(e),
                      );
                    }).toList(),
                    onChanged: (value) {
                      _formNotifier.value['export_type'] = value!;
                    },
                  ),
                  ValueListenableBuilder(
                    valueListenable: _isSpesificUnit,
                    builder: (context, value, child) {
                      return CheckboxListTile(
                        value: value,
                        title: const Text('Export Spesific Unit'),
                        contentPadding: const EdgeInsets.all(0),
                        controlAffinity: ListTileControlAffinity.leading,
                        onChanged: (newValue) {
                          _isSpesificUnit.value = newValue!;
                          _formNotifier.value['is_spesific_unit'] = newValue;
                        },
                      );
                    },
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () {},
                      child: const Text('Submit'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
