import 'package:flutter/foundation.dart' show immutable;

class SpaceTab2 {
  final String? title;
  final String? param;
  final List<SpaceTab2Item>? items;

  const SpaceTab2({this.title, this.param, this.items});

  factory SpaceTab2.fromJson(Map<String, dynamic> json) => SpaceTab2(
    title: json['title'] as String?,
    param: json['param'] as String?,
    items: (json['items'] as List<dynamic>?)
        ?.map((e) => SpaceTab2Item.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

class SpaceTab2Item {
  final String? title;
  final String? param;
  final List<SpaceTab2SubItem>? items;
  final List<SpaceTabFilter>? filter;
  final int? seasonId;
  final int? seriesId;

  const SpaceTab2Item({
    this.title,
    this.param,
    this.items,
    this.filter,
    this.seasonId,
    this.seriesId,
  });

  factory SpaceTab2Item.fromJson(Map<String, dynamic> json) => SpaceTab2Item(
    title: json["title"],
    param: json["param"],
    items: (json["items"] as List?)
        ?.map((e) => SpaceTab2SubItem.fromJson(e))
        .toList(),
    filter: (json["filter"] as List?)
        ?.map((e) => SpaceTabFilter.fromJson(e))
        .toList(),
    seasonId: json['season_id'],
    seriesId: json['series_id'],
  );
}

class SpaceTab2SubItem {
  String? title;
  String? param;
  List<SpaceTabFilter>? filter;
  int? seasonId;
  int? seriesId;

  SpaceTab2SubItem({
    this.title,
    this.param,
    this.filter,
    this.seasonId,
    this.seriesId,
  });

  factory SpaceTab2SubItem.fromJson(Map<String, dynamic> json) =>
      SpaceTab2SubItem(
        title: json["title"],
        param: json["param"],
        filter: (json["filter"] as List?)
            ?.map((e) => SpaceTabFilter.fromJson(e))
            .toList(),
        seasonId: json["season_id"],
        seriesId: json["series_id"],
      );
}

@immutable
class SpaceTabFilter {
  final String? text;
  final String meta;
  final String? tabName;

  const SpaceTabFilter({
    this.text,
    this.meta = 'all',
    this.tabName,
  });

  factory SpaceTabFilter.fromJson(Map<String, dynamic> json) => SpaceTabFilter(
    text: json["text"],
    meta: json["meta"] ?? 'all',
    tabName: json["tab_name"],
  );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is SpaceTabFilter) {
      return meta == other.meta;
    }
    return false;
  }

  @override
  int get hashCode => meta.hashCode;
}
