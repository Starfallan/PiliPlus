class DanmakuBlockDataModel {
  late List<SimpleRule> rule;
  late List<SimpleRule> rule1;
  late List<SimpleRule> rule2;
  String? toast;
  int? valid;
  int? ver;

  DanmakuBlockDataModel.fromJson(Map<String, dynamic> json) {
    rule = <SimpleRule>[];
    rule1 = <SimpleRule>[];
    rule2 = <SimpleRule>[];
    if (json['rule'] case List list) {
      for (final e in list) {
        SimpleRule item = SimpleRule.fromJson(e);
        switch (item.type) {
          case 0:
            rule.add(item);
          case 1:
            rule1.add(item);
          case 2:
            rule2.add(item);
        }
      }
    }
    toast = json['toast'] == '' ? null : json['toast'];
    valid = json['valid'];
    ver = json['ver'];
  }
}

class SimpleRule {
  late final int id;
  late final int type;
  late final String filter;

  SimpleRule.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    filter = json['filter'];
  }
}
