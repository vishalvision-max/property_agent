import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final connectivityStatusProvider = StreamProvider<ConnectivityResult>((ref) {
  final connectivity = Connectivity();
  return Stream<ConnectivityResult>.multi((controller) {
    Future<void> emitCurrent() async {
      controller.add(await connectivity.checkConnectivity());
    }

    emitCurrent();
    final sub = connectivity.onConnectivityChanged.listen(controller.add);
    controller.onCancel = () async {
      await sub.cancel();
    };
  }).distinct();
});
