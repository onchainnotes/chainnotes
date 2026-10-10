import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:chain_notes/app/app.dart';

void main() {
  testWidgets('App shows guide page', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: App()));

    expect(find.text('欢迎使用'), findsOneWidget);
    expect(find.text('登录'), findsOneWidget);
    expect(find.text('导入助记词'), findsOneWidget);
  });
}
