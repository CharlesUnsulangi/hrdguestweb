import 'package:flutter/foundation.dart';
import 'package:hrdguestweb/models/application.dart';
import 'package:hrdguestweb/models/interview_response.dart';
import 'package:hrdguestweb/models/work_experience.dart';
import 'package:hrdguestweb/services/api_service.dart';

class ApplicationViewModel extends ChangeNotifier {
  final Application application;
  final ApiService? apiService; // optional, can be null in mock mode

  bool _loading = false;

  bool get loading => _loading;

  ApplicationViewModel({String role = 'staff', this.apiService})
    : application = Application() {
    application.position = role;
  }

  void setLoading(bool v) {
    _loading = v;
    notifyListeners();
  }

  void updatePersonal({String? name, String? phone, String? email}) {
    if (name != null) application.fullName = name;
    if (phone != null) application.phone = phone;
    if (email != null) application.email = email;
    notifyListeners();
  }

  void updateKeterangan({
    String? jenis,
    String? agama,
    String? tglLahir,
    String? kota,
    String? pendidikan,
  }) {
    if (jenis != null) application.jenisKelamin = jenis;
    if (agama != null) application.agama = agama;
    if (tglLahir != null) application.tanggalLahir = tglLahir;
    if (kota != null) application.kotaLahir = kota;
    if (pendidikan != null) application.pendidikanTerakhir = pendidikan;
    notifyListeners();
  }

  void addExperience() {
    application.experiences.add(WorkExperience());
    application.interviewResponses.add(InterviewResponse());
    notifyListeners();
  }

  void removeExperience(int index) {
    if (index >= 0 && index < application.experiences.length) {
      application.experiences.removeAt(index);
      application.interviewResponses.removeAt(index);
      notifyListeners();
    }
  }

  void updateExperience(int index, WorkExperience newExp) {
    if (index >= 0 && index < application.experiences.length) {
      application.experiences[index] = newExp;
      notifyListeners();
    }
  }

  void updateInterviewResponse(int index, InterviewResponse resp) {
    if (index >= 0 && index < application.interviewResponses.length) {
      application.interviewResponses[index] = resp;
      notifyListeners();
    }
  }

  Future<bool> submit() async {
    setLoading(true);
    try {
      // If ApiService provided, call it; else simulate
      if (apiService != null) {
        final success = await apiService!.submitApplication(application);
        return success;
      } else {
        await Future.delayed(const Duration(seconds: 1));
      }
      return true;
    } finally {
      setLoading(false);
    }
  }
}
