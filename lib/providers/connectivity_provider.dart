import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// connectivity_plus 6+ reports a *list* of active transports. Collapse it to a
// single status: offline only when every transport is `none`.
ConnectivityResult _reduce(List<ConnectivityResult> results) {
  final active = results.where((r) => r != ConnectivityResult.none);
  return active.isEmpty ? ConnectivityResult.none : active.first;
}

final connectivityStatusProvider = StreamProvider<ConnectivityResult>((ref) {
  final connectivity = Connectivity();
  return Stream<ConnectivityResult>.multi((controller) {
    Future<void> emitCurrent() async {
      controller.add(_reduce(await connectivity.checkConnectivity()));
    }

    emitCurrent();
    final sub = connectivity.onConnectivityChanged
        .listen((results) => controller.add(_reduce(results)));
    controller.onCancel = () async {
      await sub.cancel();
    };
  }).distinct();
});
