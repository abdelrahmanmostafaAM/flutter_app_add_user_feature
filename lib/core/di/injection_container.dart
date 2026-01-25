import 'package:get_it/get_it.dart';
import '../../features/users/data/data_sources/user_remote_data_source.dart';
import '../../features/users/data/repositories/user_repository_impl.dart';
import '../../features/users/domain/repositories/user_repository.dart';
import '../../features/users/domain/usecases/get_user_by_id.dart';
import '../../features/users/domain/usecases/get_users.dart';
import '../../features/users/presentation/cubit/user_details/user_details_cubit.dart';
import '../../features/users/presentation/cubit/users/users_cubit.dart';
import '../network/api_client.dart';
import '../../features/products/domain/usecases/get_products.dart';
import '../../features/products/domain/usecases/get_product_by_id.dart';
import '../../features/products/domain/repositories/product_repository.dart';
import '../../features/products/data/repositories/product_repository_impl.dart';
import '../../features/products/data/data_sources/product_remote_data_source.dart';
import '../../features/products/presentation/cubit/products/products_cubit.dart';
import '../../features/products/presentation/cubit/product_details/product_details_cubit.dart';

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  // 1. ApiClient
  getIt.registerLazySingleton<ApiClient>(() => ApiClient());

  // ------------------ USERS MODULE ------------------

  // 2. Data Sources (Users)
  getIt.registerLazySingleton<UserRemoteDataSource>(
        () => UserRemoteDataSource(getIt<ApiClient>()),
  );

  // 3. Repositories (Users)
  getIt.registerLazySingleton<UserRepository>(
        () => UserRepositoryImpl(getIt<UserRemoteDataSource>()),
  );

  // 4. Use Cases (Users)
  getIt.registerLazySingleton<GetUsers>(
        () => GetUsers(getIt<UserRepository>()),
  );
  getIt.registerLazySingleton<GetUserById>(
        () => GetUserById(getIt<UserRepository>()),
  );

  // 5. Cubits (Users)
  // تم تغيير الاسم هنا ليطابق ما يطلبه التطبيق في رسالة الخطأ
  getIt.registerFactory<UsersCubit>(
        () => UsersCubit(getIt<GetUsers>()),
  );

  getIt.registerFactory<UserDetailsCubit>(
        () => UserDetailsCubit(getIt<GetUserById>()),
  );

  // ------------------ PRODUCTS MODULE (Keep if needed) ------------------
  // يمكنك الإبقاء على كود المنتجات القديم هنا إذا كنت تستخدمه في شاشات أخرى
}




/*

// GetIt instance - Dependency Injection Container
final getIt = GetIt.instance;

/// Initialize all dependencies
/// يتم استدعاء هذه الدالة في main() قبل runApp()
Future<void> setupDependencies() async {
  // 1. Register ApiClient (Network Layer)
  getIt.registerLazySingleton<ApiClient>(() => ApiClient());
  
  // 2. Register Data Sources
  getIt.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSource(getIt<ApiClient>()),
  );
  
  // 3. Register Repositories
  getIt.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(getIt<ProductRemoteDataSource>()),
  );
  
  // 4. Register Use Cases
  getIt.registerLazySingleton<GetProducts>(
    () => GetProducts(getIt<ProductRepository>()),
  );
  
  getIt.registerLazySingleton<GetProductById>(
    () => GetProductById(getIt<ProductRepository>()),
  );
  
  // 5. Register Cubits (State Management)
  // Factory: creates new instance every time (for each screen)
  getIt.registerFactory<ProductsCubit>(
    () => ProductsCubit(getIt<GetProducts>()),
  );
  
  getIt.registerFactory<ProductDetailsCubit>(
    () => ProductDetailsCubit(getIt<GetProductById>()),
  );
}

*/
