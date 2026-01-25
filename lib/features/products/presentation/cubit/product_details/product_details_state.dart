import 'package:equatable/equatable.dart';
import '../../../domain/entities/product.dart';
import '../../../../../core/errors/failures.dart';

abstract class ProductDetailsState extends Equatable {
  const ProductDetailsState();

  @override
  List<Object> get props => [];
}

class ProductDetailsInitial extends ProductDetailsState {}

class ProductDetailsLoading extends ProductDetailsState {}

class ProductDetailsLoaded extends ProductDetailsState {
  final Product product;

  const ProductDetailsLoaded(this.product);

  @override
  List<Object> get props => [product];
}

class ProductDetailsError extends ProductDetailsState {
  final Failure failure;

  const ProductDetailsError(this.failure);

  @override
  List<Object> get props => [failure];
}

