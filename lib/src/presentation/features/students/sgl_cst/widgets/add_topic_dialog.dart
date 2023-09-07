import 'package:elogbook/core/context/navigation_extension.dart';
import 'package:elogbook/core/styles/color_palette.dart';
import 'package:elogbook/core/styles/text_style.dart';
import 'package:elogbook/src/data/models/sglcst/topic_model.dart';
import 'package:elogbook/src/data/models/sglcst/topic_post_model.dart';
import 'package:elogbook/src/presentation/blocs/sgl_cst_cubit/sgl_cst_cubit.dart';
import 'package:elogbook/src/presentation/widgets/spacing_column.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum TopicDialogType {
  sgl,
  cst,
}

class AddTopicDialog extends StatefulWidget {
  final TopicDialogType type;
  final String id;
  final DateTime date;
  final String supervisorId;
  const AddTopicDialog({
    super.key,
    required this.type,
    required this.id,
    required this.date,
    required this.supervisorId,
  });

  @override
  State<AddTopicDialog> createState() => _AddTopicDialogState();
}

class _AddTopicDialogState extends State<AddTopicDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    BlocProvider.of<SglCstCubit>(context, listen: false)..getTopics();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  List<int> topicId = [];
  String? supervisorId;

  @override
  Widget build(BuildContext context) {
    return BlocListener<SglCstCubit, SglCstState>(
      listener: (context, state) {
        if (state.isNewTopicAddSuccess) {
          if (widget.type == TopicDialogType.cst) {
            BlocProvider.of<SglCstCubit>(context)..getStudentCstDetail();
          } else {
            BlocProvider.of<SglCstCubit>(context)..getStudentSglDetail();
          }
          context.back();
        }
      },
      child: Dialog(
        elevation: 0,
        insetPadding: const EdgeInsets.symmetric(
          horizontal: 36.0,
          vertical: 24.0,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 8, left: 4),
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.close_rounded,
                        color: onFormDisableColor,
                      ),
                      tooltip: 'Close',
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            widget.type == TopicDialogType.sgl
                                ? 'Add SGL Topic'
                                : 'Add CST Topic',
                            textAlign: TextAlign.center,
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 44,
                  ),
                ],
              ),
              SizedBox(
                height: 16,
              ),
              SpacingColumn(
                horizontalPadding: 16,
                spacing: 12,
                children: [
                  BlocBuilder<SglCstCubit, SglCstState>(
                      builder: (context, state) {
                    List<TopicModel> _topics = [];
                    if (state.topics != null) {
                      _topics.clear();
                      _topics.addAll(state.topics!);
                    }
                    return DropdownButtonFormField(
                      isExpanded: true,
                      hint: Text(
                        'Topic',
                      ),
                      items: _topics
                          .map(
                            (e) => DropdownMenuItem(
                              child: Text(e.name!),
                              value: e,
                            ),
                          )
                          .toList(),
                      onChanged: (v) {
                        topicId.clear();
                        if (v != null) topicId.add(v.id!);
                      },
                      value: null,
                    );
                  }),
                  TextFormField(
                    maxLines: 4,
                    minLines: 4,
                    decoration: InputDecoration(
                      label: Text(
                        'Additional notes',
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 16,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: FilledButton(
                  onPressed: () {
                    if (topicId.isNotEmpty) {
                      if (widget.type == TopicDialogType.sgl) {
                        BlocProvider.of<SglCstCubit>(context)
                          ..addNewSglTopic(
                            sglId: widget.id,
                            topicModel: TopicPostModel(
                              topicId: topicId,
                            ),
                          );
                      } else {
                        BlocProvider.of<SglCstCubit>(context)
                          ..addNewCstTopic(
                            cstId: widget.id,
                            topicModel: TopicPostModel(
                              topicId: topicId,
                            ),
                          );
                      }
                    }
                  },
                  child: Text('Submit'),
                ).fullWidth(),
              ),
              SizedBox(
                height: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
