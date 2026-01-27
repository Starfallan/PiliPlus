import 'package:PiliPlus/models_new/video/video_detail/dimension.dart';

class OgvInfo {
  int? epid;
  int? seasonId;
  int? aid;
  int? cid;
  Dimension? dimension;

  OgvInfo({this.epid, this.seasonId, this.aid, this.cid, this.dimension});

  factory OgvInfo.fromJson(Map<String, dynamic> json) => OgvInfo(
    epid: json['epid'] as int?,
    seasonId: json['season_id'] as int?,
    aid: json['aid'] as int?,
    cid: json['cid'] as int?,
    dimension: json['dimension'] == null
        ? null
        : Dimension.fromJson(json['dimension'] as Map<String, dynamic>),
  );
}
