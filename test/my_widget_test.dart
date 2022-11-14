import 'package:FakeQQ/database/database.dart';
import 'package:FakeQQ/pages/homePage.dart';
import 'package:FakeQQ/pages/loginPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main(){
  QQUser temp = QQUser.create(1, '5120205830', 'wangxiande', '123456', 'image/desktop.png');

  testWidgets('widget test', (WidgetTester tester) async {


    await tester.pumpWidget(const MaterialApp(
      home: LoginPage(),
    ));


    await tester.enterText(find.byKey(Key("input username")), "5120205830");
    await tester.enterText(find.byKey(Key("input password")), "123456");

    await tester.tap(find.byKey(const Key("button")));

    expect(find.text('5120205830'), findsOneWidget);
    expect(find.text('123456'), findsOneWidget);
  });
}