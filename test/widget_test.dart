import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_app/main.dart';
import 'package:flutter_app/core/di/injection_container.dart';
import 'package:flutter_app/features/products/presentation/cubit/products/products_cubit.dart';
import 'package:flutter_app/features/products/presentation/cubit/products/products_state.dart';

void main() {
  setUpAll(() async {
    // Initialize dependencies before running tests
    await setupDependencies();
  });

  testWidgets('Products page displays correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const FlutterApp());

    // Wait for the app to load
    await tester.pumpAndSettle();

    // Verify that Products page is displayed
    expect(find.text('Products'), findsOneWidget);
  });
}
