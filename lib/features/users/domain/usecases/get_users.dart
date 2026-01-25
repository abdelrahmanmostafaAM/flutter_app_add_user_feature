
import '../../../../core/utils/result.dart';
import '../entities/user.dart';
import '../repositories/user_repository.dart';

class GetUsers {
  final UserRepository repository;

  GetUsers(this.repository);

  Future<Result<List<User>>> call() {
    return repository.getUsers();
  }
}

