class CategorySummary {
  final String category;
  final double amount, percentage;

  const CategorySummary({
    required this.category,
    required this.amount,
    required this.percentage,
  });

  factory CategorySummary.fromJson(Map<String, dynamic> j) => CategorySummary(
    category: j['category'],
    amount: (j['amount'] as num).toDouble(),
    percentage: (j['percentage'] as num).toDouble(),
  );
}

class MonthlySummary {
  final String month;
  final double income, expenses;

  const MonthlySummary({
    required this.month,
    required this.income,
    required this.expenses,
  });

  factory MonthlySummary.fromJson(Map<String, dynamic> j) => MonthlySummary(
    month: j['month'],
    income: (j['income'] as num).toDouble(),
    expenses: (j['expenses'] as num).toDouble(),
  );
}

class DashboardModel {
  final double totalIncome, totalExpenses, balance;
  final List<CategorySummary> expenseByCategory;
  final List<MonthlySummary> monthlyTrend;

  const DashboardModel({
    required this.totalIncome,
    required this.totalExpenses,
    required this.balance,
    required this.expenseByCategory,
    required this.monthlyTrend,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> j) => DashboardModel(
    totalIncome: (j['totalIncome'] as num).toDouble(),
    totalExpenses: (j['totalExpenses'] as num).toDouble(),
    balance: (j['balance'] as num).toDouble(),
    expenseByCategory: (j['expenseByCategory'] as List)
        .map((e) => CategorySummary.fromJson(e))
        .toList(),
    monthlyTrend: (j['monthlyTrend'] as List)
        .map((e) => MonthlySummary.fromJson(e))
        .toList(),
  );
}
