import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';
import '../providers/finance_provider.dart';

class AddTransactionScreen extends ConsumerStatefulWidget {
  final TransactionModel? existing;

  const AddTransactionScreen({super.key, this.existing});

  @override
  ConsumerState<AddTransactionScreen> createState() => _AddTransactionState();
}

class _AddTransactionState extends ConsumerState<AddTransactionScreen> {
  final form = GlobalKey<FormState>();
  late String type;
  late DateTime date;
  late TextEditingController title, category, amount, note;
  bool saving = false;

  @override
  void initState() {
    super.initState();
    final t = widget.existing;
    type = t?.type ?? 'EXPENSE';
    date = t?.transactionDate ?? DateTime.now();
    title = TextEditingController(text: t?.title ?? '');
    category = TextEditingController(text: t?.category ?? '');
    amount = TextEditingController(
      text: t == null ? '' : t.amount.toStringAsFixed(2),
    );
    note = TextEditingController(text: t?.note ?? '');
  }

  @override
  void dispose() {
    title.dispose();
    category.dispose();
    amount.dispose();
    note.dispose();
    super.dispose();
  }

  Future<void> save() async {
    if (!form.currentState!.validate()) return;
    setState(() => saving = true);
    final t = TransactionModel(
      id: widget.existing?.id,
      type: type,
      category: category.text.trim(),
      title: title.text.trim(),
      amount: double.parse(amount.text),
      transactionDate: date,
      note: note.text.trim().isEmpty ? null : note.text.trim(),
    );
    try {
      final api = ref.read(apiProvider);
      widget.existing == null ? await api.create(t) : await api.update(t);
      ref.invalidate(dashboardProvider);
      ref.invalidate(transactionsProvider);
      ref.invalidate(categoriesProvider);
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted)
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(apiError(e))));
    } finally {
      if (mounted) setState(() => saving = false);
    }
  }

  @override
  Widget build(BuildContext c) {
    final editing = widget.existing != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(editing ? 'Edit transaction' : 'Add transaction'),
      ),
      body: Form(
        key: form,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(
                  value: 'EXPENSE',
                  label: Text('Expense'),
                  icon: Icon(Icons.arrow_upward),
                ),
                ButtonSegment(
                  value: 'INCOME',
                  label: Text('Income'),
                  icon: Icon(Icons.arrow_downward),
                ),
              ],
              selected: {type},
              onSelectionChanged: (s) => setState(() => type = s.first),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: title,
              decoration: const InputDecoration(
                labelText: 'Title',
                prefixIcon: Icon(Icons.description_outlined),
              ),
              validator: req,
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: category,
              decoration: const InputDecoration(
                labelText: 'Category',
                prefixIcon: Icon(Icons.category_outlined),
                hintText: 'Food, Rent, Salary...',
              ),
              validator: req,
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: amount,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: 'Amount',
                prefixIcon: Icon(Icons.currency_rupee),
              ),
              validator: (v) => v == null || (double.tryParse(v) ?? 0) <= 0
                  ? 'Enter a valid amount'
                  : null,
            ),
            const SizedBox(height: 14),
            InkWell(
              onTap: () async {
                final p = await showDatePicker(
                  context: c,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2100),
                  initialDate: date,
                );
                if (p != null) setState(() => date = p);
              },
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Date',
                  prefixIcon: Icon(Icons.calendar_today_outlined),
                ),
                child: Text(DateFormat('dd MMM yyyy').format(date)),
              ),
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: note,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Note (optional)',
                prefixIcon: Icon(Icons.notes_outlined),
              ),
            ),
            const SizedBox(height: 28),
            FilledButton.icon(
              onPressed: saving ? null : save,
              icon: saving
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.save_outlined),
              label: Text(
                saving
                    ? 'Saving...'
                    : editing
                    ? 'Update transaction'
                    : 'Save transaction',
              ),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String? req(String? v) =>
      v == null || v.trim().isEmpty ? 'This field is required' : null;
}
