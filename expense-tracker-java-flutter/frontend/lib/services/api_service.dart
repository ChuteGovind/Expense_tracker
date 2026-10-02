import 'package:dio/dio.dart';

import '../core/constants/api_constants.dart';
import '../models/dashboard.dart';
import '../models/transaction.dart';

class ApiService {
  ApiService()
    : _dio = Dio(
        BaseOptions(
          baseUrl: ApiConstants.baseUrl,
          connectTimeout: const Duration(seconds: 8),
          receiveTimeout: const Duration(seconds: 8),
          headers: {'Content-Type': 'application/json'},
        ),
      );
  final Dio _dio;

  Future<DashboardModel> getDashboard(DateTime m) async {
    final s =
        '${m.year.toString().padLeft(4, '0')}-${m.month.toString().padLeft(2, '0')}';
    final r = await _dio.get(
      ApiConstants.dashboard,
      queryParameters: {'month': s},
    );
    return DashboardModel.fromJson(r.data);
  }

  Future<List<TransactionModel>> getTransactions() async {
    final r = await _dio.get(ApiConstants.transactions);
    return (r.data as List).map((e) => TransactionModel.fromJson(e)).toList();
  }

  Future<TransactionModel> create(TransactionModel t) async {
    final r = await _dio.post(ApiConstants.transactions, data: t.toJson());
    return TransactionModel.fromJson(r.data);
  }

  Future<TransactionModel> update(TransactionModel t) async {
    final r = await _dio.put(
      '${ApiConstants.transactions}/${t.id}',
      data: t.toJson(),
    );
    return TransactionModel.fromJson(r.data);
  }

  Future<void> delete(int id) async {
    await _dio.delete('${ApiConstants.transactions}/$id');
  }

  Future<List<String>> categories() async {
    final r = await _dio.get(ApiConstants.categories);
    return (r.data as List).map((e) => e.toString()).toList();
  }
}
