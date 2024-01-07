import 'package:data/models/clinical_records/clinical_record_post_model.dart';

class ClinicalRecordData {
  ClinicalRecordPostModel _clinicalRecordPostModel = ClinicalRecordPostModel();

  ClinicalRecordPostModel get clinicalRecordPostModel =>
      _clinicalRecordPostModel;

  void clear() {
    _clinicalRecordPostModel = ClinicalRecordPostModel();
  }

  void addAttachment(String path) {
    _clinicalRecordPostModel.attachment = path;
  }

  void removeAttachment() {
    _clinicalRecordPostModel.attachment = null;
  }

  void addNotes(String notes) {
    _clinicalRecordPostModel.notes = notes;
  }

  void tempAddSecondData(
      List<ManagementPostModel> managements,
      List<DiagnosisPostModel> diagnosis,
      List<ExaminationsPostModel> examinations) {
    _clinicalRecordPostModel.managements = managements;
    _clinicalRecordPostModel.diagnosess = diagnosis;
    _clinicalRecordPostModel.examinations = examinations;
  }

  void addSupervisorId(String id) {
    _clinicalRecordPostModel.supervisorId = id;
  }

  void addRecordId(String id) {
    _clinicalRecordPostModel.recordId = id;
  }

  void addPatientData(String name, int age, String gender) {
    _clinicalRecordPostModel.patientName = name;
    _clinicalRecordPostModel.patientAge = age;
    _clinicalRecordPostModel.gender = gender;
  }

  bool isFirstDataComplete() {
    return _clinicalRecordPostModel.patientName != null &&
        _clinicalRecordPostModel.patientAge != null &&
        _clinicalRecordPostModel.supervisorId!.isNotEmpty &&
        _clinicalRecordPostModel.recordId != null &&
        _clinicalRecordPostModel.gender != null;
  }
}
