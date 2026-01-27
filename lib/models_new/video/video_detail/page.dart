import 'package:PiliPlus/models_new/video/video_detail/dimension.dart';
import 'package:PiliPlus/models_new/video/video_detail/episode.dart';

class Part extends BaseEpisodeItem {
  int? page;
  String? from;
  String? part;
  int? duration;
  String? vid;
  Dimension? dimension;
  int? ctime;
  String? firstFrame;

  Part({
    super.cid,
    this.page,
    this.from,
    this.part,
    this.duration,
    this.vid,
    this.dimension,
    this.ctime,
    this.firstFrame,
    super.badge,
  });

  factory Part.fromJson(Map<String, dynamic> json) => Part(
    cid: json['cid'] as int?,
    page: json['page'] as int?,
    from: json['from'] as String?,
    part: json['part'] as String?,
    duration: json['duration'] as int?,
    vid: json['vid'] as String?,
    dimension: json['dimension'] == null
        ? null
        : Dimension.fromJson(json['dimension'] as Map<String, dynamic>),
    ctime: json['ctime'] as int?,
    firstFrame: json['first_frame'] as String?,
    badge: json["badge"],
  );
}
