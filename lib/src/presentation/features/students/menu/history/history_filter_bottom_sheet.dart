import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/core/styles/text_style.dart';

enum Status { unverified, verified }

class HistoryFilterBottomSheet extends StatefulWidget {
  const HistoryFilterBottomSheet({super.key});

  @override
  State<HistoryFilterBottomSheet> createState() =>
      _HistoryFilterBottomSheetState();
}

class _HistoryFilterBottomSheetState extends State<HistoryFilterBottomSheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final ValueNotifier<Status> _statusNotifier;
  late final ValueNotifier<Map<String, String>> _formNotifier;

  late final TextEditingController _startDateController;
  late final TextEditingController _endDateController;

  DateTimeRange _dateRange = DateTimeRange(
    start: DateTime.now().subtract(const Duration(days: 7)),
    end: DateTime.now(),
  );

  final List<String> _activities = <String>[
    'All',
    'Clinical Record',
    'Scientific Session',
    'Self Reflection',
    'Daily Activity',
  ];

  @override
  void initState() {
    _statusNotifier = ValueNotifier(Status.unverified);

    _formNotifier = ValueNotifier({
      'start_date': '',
      'end_date': '',
      'activity': 'all',
      'status': 'unverified',
    });

    _startDateController = TextEditingController(
      text: DateFormat('dd/MM/yyyy').format(_dateRange.start),
    );

    _endDateController = TextEditingController(
      text: DateFormat('dd/MM/yyyy').format(_dateRange.end),
    );

    super.initState();
  }

  @override
  void dispose() {
    _statusNotifier.dispose();
    _formNotifier.dispose();
    _startDateController.dispose();
    _endDateController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 30),
      decoration: const BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      child: ValueListenableBuilder(
          valueListenable: _formNotifier,
          builder: (context, data, child) {
            return Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Center(
                      child: Container(
                        width: 48,
                        height: 4,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2),
                          color: const Color(0xFFD1D5DB),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: <Widget>[
                        const Icon(
                          Icons.filter_list_rounded,
                          color: primaryColor,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Filter',
                          style: textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: primaryColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Choose the date range',
                      style: textTheme.titleSmall?.copyWith(
                        color: const Color(0xFF6B7280),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: TextFormField(
                            controller: _startDateController,
                            keyboardType: TextInputType.none,
                            showCursor: false,
                            decoration: const InputDecoration(
                              label: Text('Start Date'),
                            ),
                            onSaved: (value) {
                              _formNotifier.value['start_date'] = value!;
                            },
                            onTap: () => showFilterDateRangePicker(context),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: _endDateController,
                            keyboardType: TextInputType.none,
                            showCursor: false,
                            decoration: const InputDecoration(
                              label: Text('End Date'),
                            ),
                            onSaved: (value) {
                              _formNotifier.value['end_date'] = value!;
                            },
                            onTap: () => showFilterDateRangePicker(context),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Select Activity',
                      style: textTheme.titleSmall?.copyWith(
                        color: const Color(0xFF6B7280),
                      ),
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField(
                      value: _activities.first.toLowerCase(),
                      items: _activities.map((e) {
                        return DropdownMenuItem(
                          value: e.toLowerCase(),
                          child: Text(e),
                        );
                      }).toList(),
                      onChanged: (value) {
                        _formNotifier.value['activity'] = value!;
                      },
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Status',
                      style: textTheme.titleSmall?.copyWith(
                        color: const Color(0xFF6B7280),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ValueListenableBuilder(
                      valueListenable: _statusNotifier,
                      builder: (context, status, child) {
                        return SizedBox(
                          width: double.infinity,
                          child: SegmentedButton(
                            selected: {status},
                            selectedIcon: const Icon(
                              Icons.check_rounded,
                              color: primaryColor,
                            ),
                            segments: <ButtonSegment<Status>>[
                              ButtonSegment(
                                value: Status.unverified,
                                label: Text(
                                  'Unverified',
                                  style: TextStyle(
                                    color: status == Status.unverified
                                        ? primaryColor
                                        : primaryTextColor,
                                  ),
                                ),
                              ),
                              ButtonSegment(
                                value: Status.verified,
                                label: Text(
                                  'Verified',
                                  style: TextStyle(
                                    color: status == Status.verified
                                        ? primaryColor
                                        : primaryTextColor,
                                  ),
                                ),
                              ),
                            ],
                            onSelectionChanged: (value) {
                              _statusNotifier.value = value.first;
                              _formNotifier.value['status'] = value.first.name;
                            },
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {
                          _formKey.currentState!.save();

                          print(data);

                          Navigator.pop(context, data);
                        },
                        child: const Text(
                          'Apply',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }

  Future<void> showFilterDateRangePicker(BuildContext context) async {
    final newDateRange = await showDateRangePicker(
      context: context,
      initialDateRange: _dateRange,
      firstDate: DateTime(_dateRange.start.year),
      lastDate: DateTime.now(),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      helpText: 'Specify the date range',
    );

    if (newDateRange != null) {
      _dateRange = newDateRange;

      _startDateController.text =
          DateFormat('dd/MM/yyyy').format(newDateRange.start);
      _endDateController.text =
          DateFormat('dd/MM/yyyy').format(newDateRange.end);
    }
  }
}
