// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:property_agent/main.dart';
import 'package:property_agent/data/repositories/property_repository.dart';
import 'package:property_agent/data/services/mock_property_service.dart';
import 'package:property_agent/providers/app_providers.dart';

void main() {
  testWidgets('App boots', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          propertyRepositoryProvider.overrideWithValue(
            PropertyRepository(propertyService: MockPropertyService()),
          ),
        ],
        child: const PropertyAgentApp(),
      ),
    );
    await tester.pumpAndSettle(const Duration(seconds: 2));
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
