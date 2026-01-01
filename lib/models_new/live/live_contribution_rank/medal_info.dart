class MedalInfo {
  String? medalName;
  int? level;

  MedalInfo({
    this.medalName,
    this.level,
  });

  factory MedalInfo.fromJson(Map<String, dynamic> json) => MedalInfo(
    medalName: json['medal_name'] as String?,
    level: json['level'] as int?,
  );
}
