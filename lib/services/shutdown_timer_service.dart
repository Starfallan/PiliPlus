// 定时关闭服务
import 'dart:async';
import 'dart:io';

import 'package:PiliPlus/plugin/pl_player/controller.dart';
import 'package:PiliPlus/plugin/pl_player/models/play_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

class ShutdownTimerService with WidgetsBindingObserver {
  static final ShutdownTimerService _instance =
      ShutdownTimerService._internal();
  Timer? _shutdownTimer;
  Timer? _autoCloseDialogTimer;
  //定时退出
  int scheduledExitInMinutes = 0;
  bool exitApp = false;
  bool waitForPlayingCompleted = false;
  bool isWaiting = false;
  bool isInBackground = false;
  factory ShutdownTimerService() => _instance;

  ShutdownTimerService._internal() {
    WidgetsBinding.instance.addObserver(this); // 添加观察者
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this); // 移除观察者
    _shutdownTimer?.cancel();
    _autoCloseDialogTimer?.cancel();
    _instance.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    isInBackground = state == AppLifecycleState.paused;
  }

  void startShutdownTimer() {
    cancelShutdownTimer(); // Cancel any previous timer
    if (scheduledExitInMinutes == 0) {
      //使用toast提示用户已取消
      SmartDialog.showToast("取消定时关闭");
      return;
    }
    SmartDialog.showToast("设置 $scheduledExitInMinutes 分钟后定时关闭");
    _shutdownTimer = Timer(
      Duration(minutes: scheduledExitInMinutes),
      _shutdownDecider,
    );
  }

  void _showTimeUpButPauseDialog() {
    SmartDialog.show(
      builder: (dialogContext) => AlertDialog(
        title: const Text('定时关闭'),
        content: const Text('时间到啦！'),
        actions: <Widget>[
          TextButton(
            child: const Text('确认'),
            onPressed: () {
              cancelShutdownTimer();
              SmartDialog.dismiss();
            },
          ),
        ],
      ),
    );
  }

  void _showShutdownDialog() {
    if (isInBackground) {
      // if (kDebugMode) debugPrint("app在后台运行，不弹窗");
      _executeShutdown();
      return;
    }
    SmartDialog.show(
      builder: (BuildContext dialogContext) {
        // Start the 10-second timer to auto close the dialog
        _autoCloseDialogTimer?.cancel();
        _autoCloseDialogTimer = Timer(const Duration(seconds: 10), () {
          SmartDialog.dismiss(); // Close the dialog
          _executeShutdown();
        });
        return AlertDialog(
          title: const Text('定时关闭'),
          content: const Text('将在10秒后执行，是否需要取消？'),
          actions: <Widget>[
            TextButton(
              child: const Text('取消关闭'),
              onPressed: () {
                _autoCloseDialogTimer?.cancel(); // Cancel the auto-close timer
                cancelShutdownTimer(); // Cancel the shutdown timer
                SmartDialog.dismiss(); // Close the dialog
              },
            ),
          ],
        );
      },
    ).whenComplete(() {
      // Cleanup when the dialog is dismissed
      _autoCloseDialogTimer?.cancel();
    });
  }

  void _shutdownDecider() {
    if (exitApp && !waitForPlayingCompleted) {
      _showShutdownDialog();
      return;
    }
    // PlPlayerController plPlayerController = PlPlayerController.getInstance();
    PlayerStatus? playerStatus = PlPlayerController.getPlayerStatusIfExists();
    if (!exitApp && !waitForPlayingCompleted) {
      // if (!plPlayerController.playerStatus.playing) {
      if (playerStatus == PlayerStatus.paused ||
          playerStatus == PlayerStatus.completed) {
        //仅提示用户
        _showTimeUpButPauseDialog();
      } else {
        _showShutdownDialog();
      }
      return;
    }
    //waitForPlayingCompleted
    if (playerStatus == PlayerStatus.paused ||
        playerStatus == PlayerStatus.completed) {
      // if (!plPlayerController.playerStatus.playing) {
      _showShutdownDialog();
      return;
    }
    SmartDialog.showToast("定时关闭时间已到，等待当前视频播放完成");
    //监听播放完成
    //该方法依赖耦合实现，不够优雅
    isWaiting = true;
  }

  void handleWaitingFinished() {
    if (isWaiting) {
      _showShutdownDialog();
      isWaiting = false;
    }
  }

  void _executeShutdown() {
    if (exitApp) {
      PlPlayerController.pauseIfExists();
      //退出app
      exit(0);
    } else {
      //暂停播放
      PlayerStatus? playerStatus = PlPlayerController.getPlayerStatusIfExists();
      if (playerStatus == PlayerStatus.playing) {
        PlPlayerController.pauseIfExists();
        waitForPlayingCompleted = true;
        SmartDialog.showToast("已暂停播放");
      } else {
        SmartDialog.showToast("当前未播放");
      }
    }
  }

  void cancelShutdownTimer() {
    isWaiting = false;
    _shutdownTimer?.cancel();
  }
}

final shutdownTimerService = ShutdownTimerService();
