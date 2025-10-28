class WorkExperience {
  String companyName;
  String hrdName;
  String hrdPhone;
  String supervisorName;
  String supervisorPhone;
  String startDate;
  String endDate;
  String initialPosition;
  String finalPosition;
  String initialSalary;
  String finalSalary;
  String resignationReason;
  String duties;
  int satisfactionRating; // 1-5
  int successRating; // 1-5
  int companyQualityRating; // 1-5

  WorkExperience({
    this.companyName = '',
    this.hrdName = '',
    this.hrdPhone = '',
    this.supervisorName = '',
    this.supervisorPhone = '',
    this.startDate = '',
    this.endDate = '',
    this.initialPosition = '',
    this.finalPosition = '',
    this.initialSalary = '',
    this.finalSalary = '',
    this.resignationReason = '',
    this.duties = '',
    this.satisfactionRating = 3,
    this.successRating = 3,
    this.companyQualityRating = 3,
  });

  Map<String, dynamic> toJson() => {
    'companyName': companyName,
    'hrdName': hrdName,
    'hrdPhone': hrdPhone,
    'supervisorName': supervisorName,
    'supervisorPhone': supervisorPhone,
    'startDate': startDate,
    'endDate': endDate,
    'initialPosition': initialPosition,
    'finalPosition': finalPosition,
    'initialSalary': initialSalary,
    'finalSalary': finalSalary,
    'resignationReason': resignationReason,
    'duties': duties,
    'satisfactionRating': satisfactionRating,
    'successRating': successRating,
    'companyQualityRating': companyQualityRating,
  };

  factory WorkExperience.fromJson(Map<String, dynamic> json) => WorkExperience(
    companyName: json['companyName'] ?? '',
    hrdName: json['hrdName'] ?? '',
    hrdPhone: json['hrdPhone'] ?? '',
    supervisorName: json['supervisorName'] ?? '',
    supervisorPhone: json['supervisorPhone'] ?? '',
    startDate: json['startDate'] ?? '',
    endDate: json['endDate'] ?? '',
    initialPosition: json['initialPosition'] ?? '',
    finalPosition: json['finalPosition'] ?? '',
    initialSalary: json['initialSalary'] ?? '',
    finalSalary: json['finalSalary'] ?? '',
    resignationReason: json['resignationReason'] ?? '',
    duties: json['duties'] ?? '',
    satisfactionRating: json['satisfactionRating'] ?? 3,
    successRating: json['successRating'] ?? 3,
    companyQualityRating: json['companyQualityRating'] ?? 3,
  );
}
