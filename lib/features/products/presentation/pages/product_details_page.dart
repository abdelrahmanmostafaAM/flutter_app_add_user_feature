import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection_container.dart';
import '../cubit/product_details/product_details_cubit.dart';
import '../cubit/product_details/product_details_state.dart';
import '../../../../features/shared/widgets/loading_widget.dart';
import '../../../../features/shared/widgets/error_widget.dart';
import '../widgets/product_details_view.dart';

class ProductDetailsPage extends StatelessWidget {
  final int productId;

  const ProductDetailsPage({
    super.key,
    required this.productId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<ProductDetailsCubit>()..getProduct(productId),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Product Details'),
        ),
        body: BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
          builder: (context, state) {
            if (state is ProductDetailsLoading) {
              return const LoadingWidget();
            } else if (state is ProductDetailsError) {
              return ErrorMessageWidget(
                failure: state.failure,
                onRetry: () {
                  context.read<ProductDetailsCubit>().getProduct(productId);
                },
              );
            } else if (state is ProductDetailsLoaded) {
              return ProductDetailsView(product: state.product);
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

