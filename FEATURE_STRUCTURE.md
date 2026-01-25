# Feature-Based Clean Architecture

## البنية الجديدة

المشروع الآن منظم حسب **Features** - كل feature له بنية مستقلة كاملة:

```
lib/
├── core/                          # Shared Core Layer
│   ├── base/                      # Base Classes للاستخدام من أي feature
│   │   ├── base_entity.dart
│   │   ├── base_model.dart
│   │   ├── base_repository.dart
│   │   ├── base_repository_impl.dart
│   │   ├── base_usecase.dart
│   │   └── base_data_source.dart
│   ├── constants/                 # API Constants
│   ├── di/                        # Dependency Injection
│   ├── errors/                    # Errors & Exceptions
│   ├── network/                   # Dio Client
│   └── utils/                     # Utilities
│
└── features/                      # Features Folder
    ├── home/                      # Home Feature Example
    │   ├── data/
    │   │   ├── data_sources/
    │   │   ├── models/
    │   │   └── repositories/
    │   ├── domain/
    │   │   ├── entities/
    │   │   ├── repositories/
    │   │   └── usecases/
    │   └── presentation/
    │       └── pages/
    │
    ├── users/                     # مثال: Users Feature (يمكن إضافته)
    │   ├── data/
    │   ├── domain/
    │   └── presentation/
    │
    └── shared/                    # Shared Widgets
        └── widgets/
```

## المميزات

✅ **كل Feature مستقل تماماً**
- له data layer خاص به
- له domain layer خاص به  
- له presentation layer خاص به

✅ **Core Layer مشترك**
- Base classes في `core/base/`
- Network, DI, Errors في `core/`
- يمكن استخدامها من أي feature

✅ **سهولة الصيانة**
- كل feature منفصل
- سهل إضافة features جديدة
- سهل حذف features

## كيفية إضافة Feature جديد

### 1. إنشاء البنية الأساسية

```
lib/features/your_feature/
├── data/
│   ├── data_sources/
│   ├── models/
│   └── repositories/
├── domain/
│   ├── entities/
│   ├── repositories/
│   └── usecases/
└── presentation/
    ├── pages/
    ├── widgets/
    └── bloc/
```

### 2. استخدام Base Classes

جميع الـ features تستخدم Base Classes من `core/base/`:

```dart
// Entity
class User extends BaseEntity { ... }

// Model
class UserModel extends BaseModel<User> { ... }

// Repository Interface
abstract class UserRepository extends BaseRepository { ... }

// Repository Implementation
class UserRepositoryImpl extends BaseRepositoryImpl implements UserRepository { ... }

// UseCase
class GetUsers implements UseCaseNoParams<List<User>> { ... }

// Data Source
class UserRemoteDataSource extends RemoteDataSource { ... }
```

### 3. مثال كامل

راجع `lib/features/README.md` لمثال كامل ومفصل على إضافة Users Feature.

## الفوائد

1. **Scalability**: سهل إضافة features جديدة
2. **Maintainability**: كل feature منفصل وسهل الصيانة
3. **Team Collaboration**: فرق مختلفة تعمل على features مختلفة
4. **Testing**: سهل اختبار كل feature بشكل مستقل
5. **Code Organization**: كود منظم وواضح

## ملاحظات

- استخدم `@injectable` للـ classes التي تحتاج DI
- بعد إضافة `@injectable`, قم بتشغيل:
  ```bash
  flutter pub run build_runner build --delete-conflicting-outputs
  ```
- Shared widgets في `features/shared/widgets/`
- Core utilities في `core/`

