class InterviewResponse {
  String successDescription;
  String challengeDescription;
  String jobQualityDescription;
  String negativeAspects;
  String positiveAspects;
  String conflictStory;
  String whatAreYouLookingFor;

  InterviewResponse({
    this.successDescription = '',
    this.challengeDescription = '',
    this.jobQualityDescription = '',
    this.negativeAspects = '',
    this.positiveAspects = '',
    this.conflictStory = '',
    this.whatAreYouLookingFor = '',
  });

  Map<String, dynamic> toJson() => {
    'successDescription': successDescription,
    'challengeDescription': challengeDescription,
    'jobQualityDescription': jobQualityDescription,
    'negativeAspects': negativeAspects,
    'positiveAspects': positiveAspects,
    'conflictStory': conflictStory,
    'whatAreYouLookingFor': whatAreYouLookingFor,
  };

  factory InterviewResponse.fromJson(Map<String, dynamic> json) =>
      InterviewResponse(
        successDescription: json['successDescription'] ?? '',
        challengeDescription: json['challengeDescription'] ?? '',
        jobQualityDescription: json['jobQualityDescription'] ?? '',
        negativeAspects: json['negativeAspects'] ?? '',
        positiveAspects: json['positiveAspects'] ?? '',
        conflictStory: json['conflictStory'] ?? '',
        whatAreYouLookingFor: json['whatAreYouLookingFor'] ?? '',
      );
}
