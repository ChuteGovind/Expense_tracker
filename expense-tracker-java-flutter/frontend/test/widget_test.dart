import 'package:expense_tracker/main.dart';
import 'package:expense_tracker/models/dashboard.dart';
import 'package:expense_tracker/providers/finance_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('dashboard shows the monthly summary', (WidgetTester tester) async {
    const dashboard = DashboardModel(
      totalIncome: 2500,
      totalExpenses: 900,
      balance: 1600,
      expenseByCategory: [],
      monthlyTrend: [],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [dashboardProvider.overrideWith((ref) async => dashboard)],
        child: const ExpenseTrackerApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('ExpenseFlow'), findsOneWidget);
    expect(find.text('Income'), findsOneWidget);
    expect(find.text('Expenses'), findsOneWidget);
    expect(find.text('Balance'), findsOneWidget);
    expect(find.text('Transaction'), findsOneWidget);
  });
}
