import 'package:flutter_riverpod/flutter_riverpod.dart';

extension AsyncValueX<T> on AsyncValue<T> {
  bool get isLoadingOrRefreshing => isLoading || isRefreshing;
}

