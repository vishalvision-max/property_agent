import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/property_provider.dart';
import '../../widgets/error_state.dart';
import '../../widgets/shimmer_list.dart';
import 'property_create_screen.dart';

class PropertyEditScreen extends ConsumerWidget {
  const PropertyEditScreen({super.key, required this.propertyId});

  final String propertyId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(propertyByIdProvider(propertyId));

    return async.when(
      loading: () => const SafeArea(
        child: Scaffold(body: ShimmerList(itemCount: 6)),
      ),
      error: (e, _) => SafeArea(
        child: Scaffold(
          body: ErrorState(
            title: 'Failed to load property',
            subtitle: e.toString(),
            onRetry: () => ref.invalidate(propertyByIdProvider(propertyId)),
          ),
        ),
      ),
      data: (p) => PropertyCreateScreen(initialProperty: p),
    );
  }
}

