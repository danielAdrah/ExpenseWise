import '../entities/limit_entity.dart';

abstract class LimitRepository {
  Future<void> addLimit(LimitEntity limit);
  Future<void> updateLimit(LimitEntity limit);
  Future<void> deleteLimit(String id);
  Future<List<LimitEntity>> getLimits(String accountId);
  Future<void> updateLimitSpending(String id, double amount);
}