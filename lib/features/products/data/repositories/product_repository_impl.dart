import 'package:flutter_app/features/products/domain/entities/product.dart';
import 'package:flutter_app/features/products/domain/repositories/product_repository.dart';

import '../../../../core/utils/result.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/errors/exceptions.dart';
import '../data_sources/product_remote_data_source.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;

  ProductRepositoryImpl(this.remoteDataSource);

  @override
  Future<Result<List<Product>>> getProducts() async {
    try {
      final models = await remoteDataSource.getProducts();
      final entities = models.map((model) => model.toEntity()).toList();
      return Success(entities);
    } catch (e) {
      return _handleError(e);
    }
  }

  @override
  Future<Result<Product>> getProductById(int id) async {
    try {
      final model = await remoteDataSource.getProductById(id);
      return Success(model.toEntity());
    } catch (e) {
      return _handleError(e);
    }
  }

  Result<T> _handleError<T>(dynamic error) {
    if (error is ServerException) {
      return Error(ServerFailure(error.message));
    } else if (error is NetworkException) {
      return Error(NetworkFailure(error.message));
    } else if (error is CacheException) {
      return Error(CacheFailure(error.message));
    } else {
      return Error(UnknownFailure('An unknown error occurred'));
    }
  }
}

