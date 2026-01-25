import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_products.dart';
import '../../../domain/entities/product.dart';
import '../../../../../core/utils/result.dart';
import 'products_state.dart';

class ProductsCubit extends Cubit<ProductsState> {
  final GetProducts getProducts;

  ProductsCubit(this.getProducts) : super(ProductsInitial());

  Future<void> getProductsList() async {
    emit(ProductsLoading());
    final result = await getProducts();
    if (result is Success<List<Product>>) {
      emit(ProductsLoaded(result.data));
    } else if (result is Error<List<Product>>) {
      emit(ProductsError(result.failure));
    }
  }
}

