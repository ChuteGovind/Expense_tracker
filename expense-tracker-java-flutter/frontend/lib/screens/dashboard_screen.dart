import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../providers/finance_provider.dart';
import '../widgets/expense_chart.dart';
import '../widgets/summary_card.dart';
import 'add_transaction_screen.dart';
import 'transactions_screen.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext c, WidgetRef ref) {
    final month = ref.watch(selectedMonthProvider);
    final a = ref.watch(dashboardProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ExpenseFlow', style: TextStyle(fontWeight: FontWeight.w900)),
            Text(
              'Personal finance dashboard',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.push(
              c,
              MaterialPageRoute(builder: (_) => const TransactionsScreen()),
            ),
            icon: const Icon(Icons.receipt_long_outlined),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          c,
          MaterialPageRoute(builder: (_) => const AddTransactionScreen()),
        ),
        icon: const Icon(Icons.add),
        label: const Text('Transaction'),
      ),
      body: a.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.cloud_off_outlined, size: 48),
                const SizedBox(height: 12),
                const Text(
                  'Backend connection problem',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(apiError(e), textAlign: TextAlign.center),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: () => ref.invalidate(dashboardProvider),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
        data: (d) => RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(dashboardProvider);
            await ref.read(dashboardProvider.future);
          },
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
            children: [
              monthSelector(c, ref, month),
              const SizedBox(height: 14),
              LayoutBuilder(
                builder: (_, box) {
                  final cards = [
                    SummaryCard(
                      label: 'Income',
                      value: money(d.totalIncome),
                      icon: Icons.trending_down_rounded,
                      bg: Colors.green.shade50,
                    ),
                    SummaryCard(
                      label: 'Expenses',
                      value: money(d.totalExpenses),
                      icon: Icons.trending_up_rounded,
                      bg: Colors.red.shade50,
                    ),
                    SummaryCard(
                      label: 'Balance',
                      value: money(d.balance),
                      icon: Icons.account_balance_wallet_outlined,
                      bg: Colors.blue.shade50,
                    ),
                  ];
                  if (box.maxWidth < 720)
                    return Column(
                      children: [
                        for (final x in cards)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: x,
                          ),
                      ],
                    );
                  return Row(
                    children: [
                      for (int i = 0; i < cards.length; i++)
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(right: i == 2 ? 0 : 10),
                            child: cards[i],
                          ),
                        ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 18),
              section(
                'Spending by category',
                ExpenseChart(data: d.expenseByCategory),
              ),
              const SizedBox(height: 18),
              section('6-month trend', trend(d.monthlyTrend)),
              const SizedBox(height: 18),
              FilledButton.tonalIcon(
                onPressed: () => Navigator.push(
                  c,
                  MaterialPageRoute(builder: (_) => const TransactionsScreen()),
                ),
                icon: const Icon(Icons.list_alt),
                label: const Text('View all transactions'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget monthSelector(BuildContext c, WidgetRef ref, DateTime m) => Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
    child: Row(
      children: [
        IconButton(
          onPressed: () => ref.read(selectedMonthProvider.notifier).state =
              DateTime(m.year, m.month - 1),
          icon: const Icon(Icons.chevron_left),
        ),
        Expanded(
          child: Center(
            child: Text(
              DateFormat('MMMM yyyy').format(m),
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
            ),
          ),
        ),
        IconButton(
          onPressed: () => ref.read(selectedMonthProvider.notifier).state =
              DateTime(m.year, m.month + 1),
          icon: const Icon(Icons.chevron_right),
        ),
      ],
    ),
  );

  Widget section(String title, Widget child) => Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    child: Padding(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 18),
          child,
        ],
      ),
    ),
  );

  Widget trend(List data) {
    if (data.isEmpty)
      return const SizedBox(
        height: 180,
        child: Center(child: Text('No trend data.')),
      );
    final max = data.fold<double>(
      0,
      (m, e) => [m, e.income, e.expenses].reduce((a, b) => a > b ? a : b),
    );
    return SizedBox(
      height: 230,
      child: CustomPaint(painter: TrendPainter(data, max)),
    );
  }

  String money(double v) => '₹${NumberFormat('#,##0.00').format(v)}';
}

class TrendPainter extends CustomPainter {
  final List data;
  final double max;

  TrendPainter(this.data, this.max);

  @override
  void paint(Canvas canvas, Size s) {
    final grid = Paint()
      ..color = Colors.grey.shade200
      ..strokeWidth = 1;
    final inc = Paint()
      ..color = Colors.green
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;
    final exp = Paint()
      ..color = Colors.red
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;
    for (int i = 0; i < 4; i++) {
      final y = s.height * i / 3;
      canvas.drawLine(Offset(0, y), Offset(s.width, y), grid);
    }
    if (data.length < 2 || max <= 0) return;
    final a = Path(), b = Path();
    for (int i = 0; i < data.length; i++) {
      final x = s.width * i / (data.length - 1),
          iy = s.height - (data[i].income / max) * s.height,
          ey = s.height - (data[i].expenses / max) * s.height;
      if (i == 0) {
        a.moveTo(x, iy);
        b.moveTo(x, ey);
      } else {
        a.lineTo(x, iy);
        b.lineTo(x, ey);
      }
    }
    canvas.drawPath(a, inc);
    canvas.drawPath(b, exp);
  }

  @override
  bool shouldRepaint(covariant TrendPainter old) =>
      old.data != data || old.max != max;
}
