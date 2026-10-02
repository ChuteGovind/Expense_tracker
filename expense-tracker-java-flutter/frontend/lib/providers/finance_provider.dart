import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/dashboard.dart';
import '../models/transaction.dart';
import '../services/api_service.dart';

final apiProvider = Provider<ApiService>((ref) => ApiService());
final selectedMonthProvider = StateProvider<DateTime>(
  (ref) => DateTime(DateTime.now().year, DateTime.now().month),
);
final dashboardProvider = FutureProvider.autoDispose<DashboardModel>(
  (ref) => ref.read(apiProvider).getDashboard(ref.watch(selectedMonthProvider)),
);
final transactionsProvider = FutureProvider.autoDispose<List<TransactionModel>>(
  (ref) => ref.read(apiProvider).getTransactions(),
);
final categoriesProvider = FutureProvider.autoDispose<List<String>>(
  (ref) => ref.read(apiProvider).categories(),
);

String apiError(Object e) {
  if (e is DioException &&
      (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout))
    return 'Cannot connect to backend. Start Spring Boot on port 8080.';
  if (e is DioException &&
      e.response?.data is Map &&
      e.response?.data['message'] != null)
    return e.response!.data['message'].toString();
  return 'Request failed. Please try again.';
}
