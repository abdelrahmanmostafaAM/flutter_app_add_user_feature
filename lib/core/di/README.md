# Dependency Injection (DI) - شرح

## ما هو Dependency Injection؟

**Dependency Injection** هو نمط تصميم (Design Pattern) يساعدنا على:
- فصل الكود عن الـ dependencies
- جعل الكود أسهل للاختبار
- إدارة الـ dependencies في مكان واحد

## مثال بسيط

بدون DI:
```dart
class ProductsCubit {
  // المشكلة: ProductsCubit يعتمد على GetProducts مباشرة
  final GetProducts getProducts = GetProducts(
    ProductRepositoryImpl(
      ProductRemoteDataSource(ApiClient())
    )
  );
}
```

مع DI:
```dart
class ProductsCubit {
  // الحل: نحصل على GetProducts من DI Container
  final GetProducts getProducts;
  
  ProductsCubit(this.getProducts);
}
```

## كيف يعمل في مشروعنا؟

### 1. ملف DI: `injection_container.dart`

هذا الملف يحتوي على جميع الـ dependencies:

```dart
final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  // 1. Register ApiClient
  getIt.registerLazySingleton<ApiClient>(() => ApiClient());
  
  // 2. Register Data Source
  getIt.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSource(getIt<ApiClient>()),
  );
  
  // 3. Register Repository
  getIt.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(getIt<ProductRemoteDataSource>()),
  );
  
  // 4. Register Use Case
  getIt.registerLazySingleton<GetProducts>(
    () => GetProducts(getIt<ProductRepository>()),
  );
  
  // 5. Register Cubit
  getIt.registerFactory<ProductsCubit>(
    () => ProductsCubit(getIt<GetProducts>()),
  );
}
```

### 2. الاستخدام في الكود

```dart
// في main.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupDependencies(); // تهيئة DI
  runApp(const FlutterApp());
}

// في الصفحة
BlocProvider(
  create: (context) => getIt<ProductsCubit>(), // الحصول على Cubit من DI
  child: ProductsPage(),
)
```

## أنواع التسجيل في GetIt

### 1. `registerLazySingleton`
- ينشئ instance واحد فقط
- ينشئه عند أول استخدام
- يستخدم للـ Services (ApiClient, Repository, UseCase)

```dart
getIt.registerLazySingleton<ApiClient>(() => ApiClient());
```

### 2. `registerFactory`
- ينشئ instance جديد في كل مرة
- يستخدم للـ Cubits (كل صفحة تحتاج cubit جديد)

```dart
getIt.registerFactory<ProductsCubit>(
  () => ProductsCubit(getIt<GetProducts>()),
);
```

## ترتيب التسجيل

**مهم جداً:** يجب تسجيل الـ dependencies بالترتيب الصحيح:

1. **ApiClient** (لا يعتمد على شيء)
2. **Data Sources** (يعتمد على ApiClient)
3. **Repositories** (يعتمد على Data Sources)
4. **Use Cases** (يعتمد على Repositories)
5. **Cubits** (يعتمد على Use Cases)

## مثال كامل

```dart
// 1. ApiClient (الأساس)
getIt.registerLazySingleton<ApiClient>(() => ApiClient());

// 2. Data Source (يحتاج ApiClient)
getIt.registerLazySingleton<ProductRemoteDataSource>(
  () => ProductRemoteDataSource(getIt<ApiClient>()), // ✅
);

// 3. Repository (يحتاج Data Source)
getIt.registerLazySingleton<ProductRepository>(
  () => ProductRepositoryImpl(getIt<ProductRemoteDataSource>()), // ✅
);

// 4. Use Case (يحتاج Repository)
getIt.registerLazySingleton<GetProducts>(
  () => GetProducts(getIt<ProductRepository>()), // ✅
);

// 5. Cubit (يحتاج Use Case)
getIt.registerFactory<ProductsCubit>(
  () => ProductsCubit(getIt<GetProducts>()), // ✅
);
```

## الفوائد

✅ **سهولة الاختبار**: يمكن استبدال الـ dependencies بـ mock objects
✅ **كود نظيف**: كل class لا يعرف كيف يتم إنشاء dependencies
✅ **إدارة مركزية**: كل الـ dependencies في مكان واحد
✅ **سهولة الصيانة**: تغيير implementation في مكان واحد فقط

## ملاحظات مهمة

1. **يجب استدعاء `setupDependencies()` في `main()` قبل `runApp()`**
2. **استخدم `getIt<T>()` للحصول على dependency**
3. **LazySingleton للـ Services، Factory للـ Cubits**
4. **رتب التسجيل حسب الترتيب الصحيح**

## مثال عملي

عند إضافة feature جديد:

```dart
// في injection_container.dart
Future<void> setupDependencies() async {
  // ... الـ dependencies الموجودة ...
  
  // إضافة dependencies جديدة
  getIt.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSource(getIt<ApiClient>()),
  );
  
  getIt.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(getIt<UserRemoteDataSource>()),
  );
  
  getIt.registerLazySingleton<GetUsers>(
    () => GetUsers(getIt<UserRepository>()),
  );
  
  getIt.registerFactory<UsersCubit>(
    () => UsersCubit(getIt<GetUsers>()),
  );
}
```

---

**الخلاصة**: DI يجعل الكود بسيط، نظيف، وسهل الاختبار والصيانة! 🎯

