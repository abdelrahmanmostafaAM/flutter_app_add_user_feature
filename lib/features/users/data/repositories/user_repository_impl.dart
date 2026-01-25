import '../../../../core/utils/result.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../data_sources/user_remote_data_source.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;

  UserRepositoryImpl(this.remoteDataSource);

  @override
  Future<Result<List<User>>> getUsers() async {
    try {
      final models = await remoteDataSource.getUsers();
      final entities = models.map((model) => model.toEntity()).toList();
      return Success(entities);
    } catch (e) {
      return _handleError(e);
    }
  }

  @override
  Future<Result<User>> getUserById(int id) async {
    try {
      final model = await remoteDataSource.getUserById(id);
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

