class TransactionModel {
  final int? id;
  final String type, category, title;
  final double amount;
  final DateTime transactionDate;
  final String? note;

  const TransactionModel({
    this.id,
    required this.type,
    required this.category,
    required this.title,
    required this.amount,
    required this.transactionDate,
    this.note,
  });

  bool get isIncome => type == 'INCOME';

  factory TransactionModel.fromJson(Map<String, dynamic> j) => TransactionModel(
    id: j['id'] as int?,
    type: j['type'],
    category: j['category'],
    title: j['title'],
    amount: (j['amount'] as num).toDouble(),
    transactionDate: DateTime.parse(j['transactionDate']),
    note: j['note'],
  );

  Map<String, dynamic> toJson() => {
    'type': type,
    'category': category,
    'title': title,
    'amount': amount,
    'transactionDate': transactionDate.toIso8601String().split('T').first,
    'note': note,
  };
}
