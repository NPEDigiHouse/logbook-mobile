import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:flutter/material.dart';
import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/src/presentation/features/select_units/widgets/select_unit_card.dart';

class SelectUnitPage extends StatefulWidget {
  const SelectUnitPage({super.key});

  @override
  State<SelectUnitPage> createState() => _SelectUnitPageState();
}

class _SelectUnitPageState extends State<SelectUnitPage> {
  ValueNotifier<int> _selectedIndex = ValueNotifier(0);

  @override
  void dispose() {
    super.dispose();
    _selectedIndex.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dummyUnitName = [
      "Obstetrics and Gynecology",
      "Sattelite Hospital",
      "Neuroopthalmology",
      "Infection & Immunology",
      "Vitro Retina",
      "Glaucoma",
      "Pediatric,Opthalmology, and Strabismus",
      "Emergency Unit",
    ];

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Select Unit"),
        leading: IconButton(
          onPressed: () => context.back(),
          icon: Icon(
            Icons.arrow_back,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.sort_by_alpha,
              color: primaryColor,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: ValueListenableBuilder(
            valueListenable: _selectedIndex,
            builder: (context, value, _) {
              return ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                separatorBuilder: (context, index) => SizedBox(
                  height: 16,
                ),
                itemBuilder: (context, index) {
                  return SelectUnitCard(
                    unitName: dummyUnitName[index],
                    index: index,
                    value: value,
                    selectedIndex: _selectedIndex,
                  );
                },
                itemCount: dummyUnitName.length,
              );
            }),
      ),
    );
  }
}
