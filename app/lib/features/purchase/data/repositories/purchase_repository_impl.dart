import '../../domain/entities/purchase_history_entity.dart';
import '../../domain/repositories/purchase_repository.dart';
import '../datasources/purchase_remote_data_source.dart';

class PurchaseRepositoryImpl implements PurchaseRepository {
  final PurchaseRemoteDataSource _remoteDataSource;

  PurchaseRepositoryImpl(this._remoteDataSource);

  @override
  Future<PurchaseHistoryEntity> buyItem(String itemId) async {
    final model = await _remoteDataSource.buyItem(itemId);
    return model.toEntity();
  }
}
