import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final connectivityStatusProvider = StreamProvider<List<ConnectivityResult>>((ref) {
  final connectivity = Connectivity();
  final controller = StreamController<List<ConnectivityResult>>();

  Future<void> emitCurrent() async {
    final current = await connectivity.checkConnectivity();
    controller.add(current);
  }

  emitCurrent();
  final sub = connectivity.onConnectivityChanged.listen(controller.add);
  ref.onDispose(() async {
    await sub.cancel();
    await controller.close();
  });
  return controller.stream.distinct();
});
