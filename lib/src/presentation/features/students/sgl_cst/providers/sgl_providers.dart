// import 'package:flutter/material.dart';
// import 'package:uuid/uuid.dart';

// class SglHelperModel {
//   final DateTime createdAt;
//   bool isVerified;
//   String sglId;
//   List<TopicHelper> topics;

//   SglHelperModel({
//     required this.createdAt,
//     required this.isVerified,
//     required this.sglId,
//     required this.topics,
//   });
// }

// class TopicHelper {
//   String topicName;
//   bool isVerified;
//   DateTime startTime;
//   DateTime endTime;
//   String notes;
//   String id;

//   TopicHelper(
//       {required this.topicName,
//       required this.endTime,
//       required this.id,
//       required this.isVerified,
//       required this.notes,
//       required this.startTime});
// }

// class SglNotifier extends ChangeNotifier {
//   List<SglHelperModel> sgls = [];

//   void addNewSgl({required SglHelperModel newSgl}) {
//     newSgl.sglId = Uuid().v4();
//     sgls.add(newSgl);
//   }

//   void removeSgl({required })
// }
