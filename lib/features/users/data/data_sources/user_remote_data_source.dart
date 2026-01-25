import '../../../../core/network/api_client.dart';
import '../../../../core/network/endpoints.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/user_model.dart';

class UserRemoteDataSource {
  final ApiClient apiClient;

  UserRemoteDataSource(this.apiClient);

  Future<List<UserModel>> getUsers() async {
    try {
      final response = await apiClient.get(Endpoints.users);
      final List<dynamic> data = response.data;
      return data.map((json) => UserModel.fromJson(json)).toList();
    } catch (e) {
      throw ServerException('Failed to get users: ${e.toString()}');
    }
  }

  Future<UserModel> getUserById(int id) async {
    try {
      final response = await apiClient.get(Endpoints.userById(id));
      return UserModel.fromJson(response.data);
    } catch (e) {
      throw ServerException('Failed to get user: ${e.toString()}');
    }
  }
}

