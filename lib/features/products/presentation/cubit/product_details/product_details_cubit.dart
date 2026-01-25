import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_product_by_id.dart';
import '../../../domain/entities/product.dart';
import '../../../../../core/utils/result.dart';
import 'product_details_state.dart';

class ProductDetailsCubit extends Cubit<ProductDetailsState> {
  final GetProductById getProductById;

  ProductDetailsCubit(this.getProductById) : super(ProductDetailsInitial());

  Future<void> getProduct(int productId) async {
    emit(ProductDetailsLoading());
    final result = await getProductById(productId);
    if (result is Success<Product>) {
      emit(ProductDetailsLoaded(result.data));
    } else if (result is Error<Product>) {
      emit(ProductDetailsError(result.failure));
    }
  }
}

