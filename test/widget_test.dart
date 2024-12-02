// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:challenge2/app/app.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const App());

    // 여기에 새로운 테스트 케이스를 작성할 수 있습니다.
    // 예: 하단 네비게이션 바가 표시되는지 확인
    expect(find.byType(BottomNavigationBar), findsOneWidget);

    // 홈 화면의 제목이 표시되는지 확인
    expect(find.text('홈'), findsOneWidget);
  });
}
