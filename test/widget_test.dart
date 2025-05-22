import 'package:flutter_test/flutter_test.dart';

import 'package:workout_organiser/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Построить приложение
    await tester.pumpWidget(const WorkoutOrganiserApp());

    // Здесь надо адаптировать проверки под твоё приложение
    // Например, проверить наличие текста с названием приложения:
    expect(find.text('Workout Organiser'), findsOneWidget);

    // Остальной код теста может не иметь смысла, если в твоём приложении нет счётчика
  });
}
