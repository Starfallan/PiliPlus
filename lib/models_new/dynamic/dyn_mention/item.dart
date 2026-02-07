import 'package:PiliPlus/pages/common/multi_select/base.dart';

class MentionItem with MultiSelectData {
  final String? face;
  final int? fans;
  final String? name;
  final int? officialVerifyType;
  final String? uid;

  MentionItem({
    this.face,
    this.fans,
    this.name,
    this.officialVerifyType,
    this.uid,
  });

  factory MentionItem.fromJson(Map<String, dynamic> json) => MentionItem(
    face: json['face'] as String?,
    fans: json['fans'] as int?,
    name: json['name'] as String?,
    officialVerifyType: json['official_verify_type'] as int?,
    uid: json['uid'] as String?,
  );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is MentionItem) {
      return uid == other.uid;
    }
    return false;
  }

  @override
  int get hashCode => uid.hashCode;
}
