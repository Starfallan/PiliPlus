import 'package:PiliPlus/grpc/bilibili/main/community/reply/v1.pb.dart'
    show MainListReply, ReplyInfo;
import 'package:PiliPlus/grpc/reply.dart';
import 'package:PiliPlus/http/loading_state.dart';
import 'package:PiliPlus/pages/common/reply_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainReplyController extends ReplyController<MainListReply>
    with GetSingleTickerProviderStateMixin {
  late final int oid;
  late final int replyType;

  @override
  int get sourceId => oid;

  bool _showFab = true;

  late final AnimationController _fabAnimationCtr;
  late final Animation<Offset> fabAnim;

  @override
  void onInit() {
    super.onInit();
    _fabAnimationCtr = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..forward();
    fabAnim = _fabAnimationCtr.drive(
      Tween<Offset>(
        begin: const Offset(0.0, 2.0),
        end: Offset.zero,
      ).chain(CurveTween(curve: Curves.easeInOut)),
    );
    final args = Get.arguments;
    oid = args['oid'];
    replyType = args['replyType'];

    queryData();
  }

  void showFab() {
    if (!_showFab) {
      _showFab = true;
      _fabAnimationCtr.forward();
    }
  }

  void hideFab() {
    if (_showFab) {
      _showFab = false;
      _fabAnimationCtr.reverse();
    }
  }

  @override
  Future<LoadingState<MainListReply>> customGetData() => ReplyGrpc.mainList(
    type: replyType,
    oid: oid,
    mode: mode.value,
    cursorNext: cursorNext,
    offset: paginationReply?.nextOffset,
  );

  @override
  List<ReplyInfo>? getDataList(MainListReply response) => response.replies;

  @override
  void onClose() {
    _fabAnimationCtr.dispose();
    super.onClose();
  }
}
