import '../../../../core/network/api_client.dart';
import '../../../../core/network/endpoints.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/product_model.dart';

class ProductRemoteDataSource {
  final ApiClient apiClient;

  ProductRemoteDataSource(this.apiClient);

  Future<List<ProductModel>> getProducts() async {
    try {
      final response = await apiClient.get(Endpoints.products);

      // 1. التأكد من أن البيانات ليست فارغة وتحويلها بأمان
      if (response.data != null) {
        final List<dynamic> data = response.data;
        return data.map((json) => ProductModel.fromJson(json as Map<String, dynamic>)).toList();
      } else {
        throw ServerException('Data is null');
      }
    } on ServerException {
      // إعادة تمرير استثناءات السيرفر المعروفة
      rethrow;
    } catch (e) {
      // 2. تحويل أي خطأ غير متوقع إلى ServerException
      throw ServerException(e.toString());
    }
  }

  Future<ProductModel> getProductById(int id) async {
    try {
      final response = await apiClient.get(Endpoints.productById(id));

      // 3. فحص الـ response.data قبل التحويل
      if (response.data != null) {
        return ProductModel.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw ServerException('Product not found');
      }
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}