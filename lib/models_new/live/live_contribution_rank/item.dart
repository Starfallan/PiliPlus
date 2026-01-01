import 'package:PiliPlus/models_new/live/live_contribution_rank/medal_info.dart';

class LiveContributionRankItem {
  int? uid;
  String? name;
  String? face;
  int? rank;
  int? score;
  MedalInfo? medalInfo;

  LiveContributionRankItem({
    this.uid,
    this.name,
    this.face,
    this.rank,
    this.score,
    this.medalInfo,
  });

  factory LiveContributionRankItem.fromJson(Map<String, dynamic> json) =>
      LiveContributionRankItem(
        uid: json['uid'] as int?,
        name: json['name'] as String?,
        face: json['face'] as String?,
        rank: json['rank'] as int?,
        score: json['score'] as int?,
        medalInfo: json['medal_info'] == null
            ? null
            : MedalInfo.fromJson(json['medal_info'] as Map<String, dynamic>),
      );
}
