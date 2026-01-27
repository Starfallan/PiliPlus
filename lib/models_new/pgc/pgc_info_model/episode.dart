import 'package:PiliPlus/models_new/pgc/pgc_info_model/badge_info.dart';
import 'package:PiliPlus/models_new/pgc/pgc_info_model/rights.dart';
import 'package:PiliPlus/models_new/pgc/pgc_info_model/skip.dart';
import 'package:PiliPlus/models_new/video/video_detail/dimension.dart';
import 'package:PiliPlus/models_new/video/video_detail/episode.dart'
    show BaseEpisodeItem;

class EpisodeItem extends BaseEpisodeItem {
  BadgeInfo? badgeInfo;
  int? badgeType;
  Dimension? dimension;
  int? duration; // pgc: millisec , pugv: sec
  bool? enableVt;
  String? from;
  bool? isViewHide;
  String? link;
  String? longTitle;
  int? pubTime;
  int? pv;
  // String? releaseDate;
  Rights? rights;
  int? sectionType;
  String? shareCopy;
  String? shareUrl;
  String? shortLink;
  bool? showDrmLoginDialog;
  String? showTitle;
  Skip? skip;
  int? status;
  String? subtitle;
  String? vid;
  int? play;

  EpisodeItem({
    super.aid,
    super.badge,
    this.badgeInfo,
    this.badgeType,
    super.bvid,
    super.cid,
    super.cover,
    this.dimension,
    this.duration,
    this.enableVt,
    super.epId,
    this.from,
    super.id,
    this.isViewHide,
    this.link,
    this.longTitle,
    this.pubTime,
    this.pv,
    // this.releaseDate,
    this.rights,
    this.sectionType,
    this.shareCopy,
    this.shareUrl,
    this.shortLink,
    this.showDrmLoginDialog,
    this.showTitle,
    this.skip,
    this.status,
    this.subtitle,
    super.title,
    this.vid,
    this.play,
  });

  factory EpisodeItem.fromJson(Map<String, dynamic> json) => EpisodeItem(
    aid: json['aid'] as int?,
    badge: json['badge'] as String?,
    badgeInfo: json['badge_info'] == null
        ? null
        : BadgeInfo.fromJson(json['badge_info'] as Map<String, dynamic>),
    badgeType: json['badge_type'] as int?,
    bvid: json['bvid'] as String?,
    cid: json['cid'] as int?,
    cover: json['cover'] as String?,
    dimension: json['dimension'] == null
        ? null
        : Dimension.fromJson(json['dimension'] as Map<String, dynamic>),
    duration: json['duration'] as int?,
    enableVt: json['enable_vt'] as bool?,
    epId: json['ep_id'] as int?,
    from: json['from'] as String?,
    id: json['id'] as int?,
    isViewHide: json['is_view_hide'] as bool?,
    link: json['link'] as String?,
    longTitle: json['long_title'] as String?,
    pubTime: json['pub_time'] ?? json['release_date'],
    pv: json['pv'] as int?,
    // releaseDate: json['release_date'] as String?,
    rights: json['rights'] == null
        ? null
        : Rights.fromJson(json['rights'] as Map<String, dynamic>),
    sectionType: json['section_type'] as int?,
    shareCopy: json['share_copy'] as String?,
    shareUrl: json['share_url'] as String?,
    shortLink: json['short_link'] as String?,
    showDrmLoginDialog: json['showDrmLoginDialog'] as bool?,
    showTitle: json['show_title'] as String?,
    skip: json['skip'] == null
        ? null
        : Skip.fromJson(json['skip'] as Map<String, dynamic>),
    status: json['status'] as int?,
    subtitle: json['subtitle'] as String?,
    title: json['title'] as String?,
    vid: json['vid'] as String?,
    play: json['play'] as int?,
  );
}
