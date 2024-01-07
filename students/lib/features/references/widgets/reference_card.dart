import 'package:core/styles/color_palette.dart';
import 'package:data/models/reference/reference_on_list_model.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:main/widgets/inkwell_container.dart';

class ReferenceCard extends StatefulWidget {
  final ReferenceOnListModel reference;
  final VoidCallback onTap;
  const ReferenceCard({
    required this.reference,
    super.key,
    required this.onTap,
  });

  @override
  State<ReferenceCard> createState() => _ReferenceCardState();
}

class _ReferenceCardState extends State<ReferenceCard> {
  @override
  Widget build(BuildContext context) {
    return InkWellContainer(
      radius: 12,
      onTap: widget.onTap,
      padding: const EdgeInsets.symmetric(
        vertical: 12,
        horizontal: 16,
      ),
      color: scaffoldBackgroundColor,
      boxShadow: [
        BoxShadow(
          offset: const Offset(0, 4),
          blurRadius: 24,
          spreadRadius: 0,
          color: const Color(0xFF374151).withOpacity(
            .15,
          ),
        )
      ],
      child: SizedBox(
        height: 45,
        child: Row(
          children: [
            const SizedBox(
              width: 4,
            ),
            Icon(
              widget.reference.type == 'URL'
                  ? Icons.link
                  : Icons.file_present_outlined,
              color: primaryColor,
            ),
            const SizedBox(
              width: 12,
            ),
            const VerticalDivider(),
            const SizedBox(
              width: 12,
            ),
            Expanded(
              child: Text(
                widget.reference.type == 'URL'
                    ? widget.reference.filename ??
                        widget.reference.file ??
                        'nonamed'
                    : p.basename(widget.reference.file!),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            )
          ],
        ),
      ),
    );
  }
}
