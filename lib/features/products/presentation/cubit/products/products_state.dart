import 'package:equatable/equatable.dart';
import '../../../domain/entities/product.dart';
import '../../../../../core/errors/failures.dart';

abstract class ProductsState extends Equatable {
  const ProductsState();

  @override
  List<Object> get props => [];
}

class ProductsInitial extends ProductsState {}

class ProductsLoading extends ProductsState {}

class ProductsLoaded extends ProductsState {
  final List<Product> products;

  const ProductsLoaded(this.products);

  @override
  List<Object> get props => [products];
}

class ProductsError extends ProductsState {
  final Failure failure;

  const ProductsError(this.failure);

  @override
  List<Object> get props => [failure];
}

