// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:biblioteca_escolar/main.dart';

void main() {
  testWidgets('abre el catálogo y permite eliminar un libro', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const BibliotecaApp());

    expect(find.text('Hola, lector'), findsOneWidget);
    await tester.tap(find.byTooltip('Abrir catálogo'));
    await tester.pumpAndSettle();

    expect(find.text('Cien años de soledad'), findsOneWidget);
    await tester.drag(
      find.byKey(const ValueKey('book-1')),
      const Offset(-500, 0),
    );
    await tester.pumpAndSettle();

    expect(find.text('Cien años de soledad'), findsNothing);
    expect(find.textContaining('se quitó del catálogo.'), findsOneWidget);
  });

  testWidgets('abre el detalle al tocar un libro', (WidgetTester tester) async {
    await tester.pumpWidget(const BibliotecaApp());
    await tester.tap(find.byTooltip('Abrir catálogo'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('El principito'));
    await tester.pumpAndSettle();

    expect(find.text('Detalle del libro'), findsOneWidget);
    expect(find.textContaining('Antoine de Saint-Exupéry'), findsOneWidget);
  });
}
