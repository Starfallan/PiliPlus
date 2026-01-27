// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

abstract class PopScopeState<T extends StatefulWidget> extends State<T>
    implements PopEntry<T> {
  ModalRoute<dynamic>? _route;

  @override
  void onPopInvoked(bool didPop) {}

  @override
  late final ValueNotifier<bool> canPopNotifier;

  void initCanPopNotifier() {
    canPopNotifier = ValueNotifier<bool>(false);
  }

  @override
  void initState() {
    super.initState();
    initCanPopNotifier();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final ModalRoute<dynamic>? nextRoute = ModalRoute.of(context);
    if (nextRoute != _route) {
      _route?.unregisterPopEntry(this);
      _route = nextRoute;
      _route?.registerPopEntry(this);
    }
  }

  @override
  void dispose() {
    _route?.unregisterPopEntry(this);
    canPopNotifier.dispose();
    super.dispose();
  }
}
