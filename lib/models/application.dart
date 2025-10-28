import 'package:hrdguestweb/models/interview_response.dart';
import 'package:hrdguestweb/models/social_media.dart';
import 'package:hrdguestweb/models/work_experience.dart';

class Application {
  String id;
  String fullName;
  String phone;
  String email;
  String position;

  // keterangan diri
  String jenisKelamin;
  String agama;
  String tanggalLahir;
  String kotaLahir;
  String pendidikanTerakhir;

  List<WorkExperience> experiences;
  List<InterviewResponse>
  interviewResponses; // parallel to experiences by index
  List<SocialMedia> socialMedia;

  Application({
    this.id = '',
    this.fullName = '',
    this.phone = '',
    this.email = '',
    this.position = '',
    this.jenisKelamin = '',
    this.agama = '',
    this.tanggalLahir = '',
    this.kotaLahir = '',
    this.pendidikanTerakhir = '',
    List<WorkExperience>? experiences,
    List<InterviewResponse>? interviewResponses,
    List<SocialMedia>? socialMedia,
  }) : experiences = experiences ?? [],
       interviewResponses = interviewResponses ?? [],
       socialMedia = socialMedia ?? [];

  Map<String, dynamic> toJson() => {
    'id': id,
    'fullName': fullName,
    'phone': phone,
    'email': email,
    'position': position,
    'jenisKelamin': jenisKelamin,
    'agama': agama,
    'tanggalLahir': tanggalLahir,
    'kotaLahir': kotaLahir,
    'pendidikanTerakhir': pendidikanTerakhir,
    'experiences': experiences.map((e) => e.toJson()).toList(),
    'interviewResponses': interviewResponses.map((r) => r.toJson()).toList(),
    'socialMedia': socialMedia.map((s) => s.toJson()).toList(),
  };

  factory Application.fromJson(Map<String, dynamic> json) => Application(
    id: json['id'] ?? '',
    fullName: json['fullName'] ?? '',
    phone: json['phone'] ?? '',
    email: json['email'] ?? '',
    position: json['position'] ?? '',
    jenisKelamin: json['jenisKelamin'] ?? '',
    agama: json['agama'] ?? '',
    tanggalLahir: json['tanggalLahir'] ?? '',
    kotaLahir: json['kotaLahir'] ?? '',
    pendidikanTerakhir: json['pendidikanTerakhir'] ?? '',
    experiences:
        (json['experiences'] as List<dynamic>?)
            ?.map((e) => WorkExperience.fromJson(Map<String, dynamic>.from(e)))
            .toList() ??
        [],
    interviewResponses:
        (json['interviewResponses'] as List<dynamic>?)
            ?.map(
              (e) => InterviewResponse.fromJson(Map<String, dynamic>.from(e)),
            )
            .toList() ??
        [],
    socialMedia:
        (json['socialMedia'] as List<dynamic>?)
            ?.map((s) => SocialMedia.fromJson(Map<String, dynamic>.from(s)))
            .toList() ??
        [],
  );
}
