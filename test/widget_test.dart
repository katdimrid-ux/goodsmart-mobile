import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:goods_mart_mobile/main.dart';

void main() {
  testWidgets('Goods Mart app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: GoodsMartApp()));
    expect(find.text('Goods '), findsOneWidget);
  });
}