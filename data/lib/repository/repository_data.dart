import 'package:data/models/competences/list_student_cases_model.dart';
import 'package:data/models/competences/list_student_skills_model.dart';
import 'package:data/models/sglcst/topic_model.dart';
import 'package:data/models/supervisors/supervisor_model.dart';

class RepositoryData {
  static List<SupervisorModel> supervisors = [];
  static List<TopicModel> sglTopics = [];
  static List<TopicModel> cstTopics = [];
  static List<StudentCaseModel> cases = [];
  static List<StudentSkillModel> skills = [];

  static void allClear() {
    supervisors.clear();
    sglTopics.clear();
    cstTopics.clear();
    cases.clear();
    skills.clear();
  }

  static void unitClear() {
    sglTopics.clear();
    cstTopics.clear();
    cases.clear();
    skills.clear();
  }
}
