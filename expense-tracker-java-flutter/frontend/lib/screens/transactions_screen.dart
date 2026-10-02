import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/transaction.dart';
import '../providers/finance_provider.dart';
import '../widgets/transaction_tile.dart';
import 'add_transaction_screen.dart';

class TransactionsScreen extends ConsumerWidget {
  const TransactionsScreen({super.key});

  Future<void> del(BuildContext c, WidgetRef ref, TransactionModel t) async {
    final yes = await showDialog<bool>(context: c,
        builder: (_) =>
            AlertDialog(title: const Text('Delete transaction?'),
                content: Text('Delete "${t.title}" permanently?'),
                actions: [
                  TextButton(onPressed: () => Navigator.pop(c, false),
                      child: const Text('Cancel')),
                  FilledButton(onPressed: () => Navigator.pop(c, true),
                      child: const Text('Delete'))
                ]));
    if (yes != true) return;
    try {
      await ref.read(apiProvider).delete(t.id!);
      ref.invalidate(transactionsProvider);
      ref.invalidate(dashboardProvider);
    } catch (e) {
      if (c.mounted) ScaffoldMessenger.of(c).showSnackBar(
          SnackBar(content: Text(apiError(e))));
    }
  }

  @override Widget build(BuildContext c, WidgetRef ref) {
    final a = ref.watch(transactionsProvider);
    return Scaffold(appBar: AppBar(title: const Text('Transactions'),
        actions: [
          IconButton(onPressed: () => ref.invalidate(transactionsProvider),
              icon: const Icon(Icons.refresh))
        ]),
        floatingActionButton: FloatingActionButton.extended(onPressed: () =>
            Navigator.push(c, MaterialPageRoute(
                builder: (_) => const AddTransactionScreen())),
            icon: const Icon(Icons.add),
            label: const Text('Add')),
        body: a.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) =>
                Center(child: Column(mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(apiError(e)),
                      const SizedBox(height: 12),
                      FilledButton(
                          onPressed: () => ref.invalidate(transactionsProvider),
                          child: const Text('Retry'))
                    ])),
            data: (xs) =>
            xs.isEmpty
                ? const Center(
                child: Text('No transactions yet. Tap + to add one.'))
                : ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                itemCount: xs.length,
                itemBuilder: (_, i) =>
                    InkWell(onTap: () =>
                        Navigator.push(c, MaterialPageRoute(builder: (_) =>
                            AddTransactionScreen(existing: xs[i]))),
                        child: TransactionTile(transaction: xs[i],
                            onDelete: () => del(c, ref, xs[i])
                        )
                    )
            )
));
}}
