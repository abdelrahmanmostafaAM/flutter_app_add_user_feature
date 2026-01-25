import '../../../../core/utils/result.dart';
import '../entities/user.dart';

abstract class UserRepository {
  Future<Result<List<User>>> getUsers();
  Future<Result<User>> getUserById(int id);
}

