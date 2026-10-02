import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../models/dashboard.dart';

class ExpenseChart extends StatelessWidget {
  final List<CategorySummary> data;

  const ExpenseChart({super.key, required this.data});

  @override
  Widget build(BuildContext c) {
    if (data.isEmpty)
      return const SizedBox(
        height: 180,
        child: Center(child: Text('No expense data for this month.')),
      );
    return Row(
      children: [
        Expanded(
          flex: 5,
          child: SizedBox(
            height: 210,
            child: PieChart(
              PieChartData(
                sectionsSpace: 3,
                centerSpaceRadius: 46,
                sections: [
                  for (final x in data)
                    PieChartSectionData(
                      value: x.amount,
                      title: '${x.percentage.toStringAsFixed(0)}%',
                      radius: 58,
                      titleStyle: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final x in data.take(5))
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: [
                      const CircleAvatar(radius: 4),
                      const SizedBox(width: 7),
                      Expanded(
                        child: Text(
                          x.category,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                      Text(
                        '₹${x.amount.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
