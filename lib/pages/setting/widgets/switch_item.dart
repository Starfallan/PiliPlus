import 'package:PiliPlus/common/widgets/dialog/dialog.dart';
import 'package:PiliPlus/common/widgets/flutter/list_tile.dart';
import 'package:PiliPlus/utils/storage.dart';
import 'package:PiliPlus/utils/storage_key.dart';
import 'package:PiliPlus/utils/storage_pref.dart';
import 'package:flutter/material.dart' hide ListTile;
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

class SetSwitchItem extends StatefulWidget {
  final String title;
  final String? subtitle;
  final String setKey;
  final bool defaultVal;
  final ValueChanged<bool>? onChanged;
  final bool needReboot;
  final Widget? leading;
  final void Function(BuildContext context)? onTap;
  final EdgeInsetsGeometry? contentPadding;
  final TextStyle? titleStyle;

  const SetSwitchItem({
    required this.title,
    this.subtitle,
    required this.setKey,
    this.defaultVal = false,
    this.onChanged,
    this.needReboot = false,
    this.leading,
    this.onTap,
    this.contentPadding,
    this.titleStyle,
    super.key,
  });

  @override
  State<SetSwitchItem> createState() => _SetSwitchItemState();
}

class _SetSwitchItemState extends State<SetSwitchItem> {
  late bool val;

  void setVal() {
    if (widget.setKey == SettingBoxKey.appFontWeight) {
      val = Pref.appFontWeight != -1;
    } else {
      val = GStorage.setting.get(
        widget.setKey,
        defaultValue: widget.defaultVal,
      );
    }
  }

  @override
  void didUpdateWidget(SetSwitchItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.setKey != widget.setKey) {
      setVal();
    }
  }

  @override
  void initState() {
    super.initState();
    setVal();
  }

  Future<void> switchChange([bool? value]) async {
    val = value ?? !val;

    if (widget.setKey == SettingBoxKey.badCertificateCallback && val) {
      val = await showConfirmDialog(
        context: context,
        title: '确定禁用 SSL 证书验证？',
        content: '禁用容易受到中间人攻击',
      );
    }

    if (widget.setKey == SettingBoxKey.enableTrialQuality && val) {
      val = await Get.dialog<bool>(
        AlertDialog(
          title: const Text('风险提示'),
          content: const Text(
            '此功能通过修改本地响应数据来尝试播放高画质流，仅用于技术学习和研究。\n\n'
            '注意事项：\n'
            '1. 此功能不破解付费内容，仅在服务器返回可访问URL时允许播放\n'
            '2. 使用此功能需自行承担风险\n'
            '3. 不建议在公开版本中启用\n'
            '4. 请遵守相关服务条款\n\n'
            '是否继续启用？',
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () => Get.back(result: true),
              child: const Text('我知道了'),
            ),
          ],
        ),
      ) ?? false; // Default to false if dialog is dismissed
    }

    if (widget.setKey == SettingBoxKey.appFontWeight) {
      await GStorage.setting.put(SettingBoxKey.appFontWeight, val ? 4 : -1);
    } else {
      await GStorage.setting.put(widget.setKey, val);
    }

    widget.onChanged?.call(val);
    if (widget.needReboot) {
      SmartDialog.showToast('重启生效');
    }
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    TextStyle titleStyle =
        widget.titleStyle ??
        theme.textTheme.titleMedium!.copyWith(
          color: widget.onTap != null && !val
              ? theme.colorScheme.outline
              : null,
        );
    TextStyle subTitleStyle = theme.textTheme.labelMedium!.copyWith(
      color: theme.colorScheme.outline,
    );
    return ListTile(
      contentPadding: widget.contentPadding,
      enabled: widget.onTap == null ? true : val,
      onTap: widget.onTap == null ? switchChange : () => widget.onTap!(context),
      title: Text(widget.title, style: titleStyle),
      subtitle: widget.subtitle != null
          ? Text(widget.subtitle!, style: subTitleStyle)
          : null,
      leading: widget.leading,
      trailing: Transform.scale(
        alignment: Alignment.centerRight,
        scale: 0.8,
        child: Switch(
          value: val,
          onChanged: switchChange,
        ),
      ),
    );
  }
}
