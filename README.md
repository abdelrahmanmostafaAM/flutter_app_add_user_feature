# Clean Architecture Flutter App

مشروع Flutter مبني على Clean Architecture مع Feature-Based Structure

## البنية (Architecture)

المشروع منظم حسب **Feature-Based Clean Architecture** - كل feature له data, domain, presentation خاص به:

```
lib/
├── core/                    # الطبقة الأساسية المشتركة
│   ├── base/                # Base Classes (Entity, Model, Repository, UseCase)
│   ├── constants/           # الثوابت (API URLs, Timeouts)
│   ├── di/                  # Dependency Injection
│   ├── errors/              # Exceptions & Failures
│   ├── network/             # Dio Client & Endpoints
│   └── utils/               # Utilities (Result, etc.)
│
└── features/                # Features - كل feature مستقل
    ├── feature_name/        # مثال: home, users, products
    │   ├── data/            # Data Layer للـ Feature
    │   │   ├── data_sources/
    │   │   ├── models/
    │   │   └── repositories/
    │   │
    │   ├── domain/          # Domain Layer للـ Feature
    │   │   ├── entities/
    │   │   ├── repositories/
    │   │   └── usecases/
    │   │
    │   └── presentation/     # Presentation Layer للـ Feature
    │       ├── pages/
    │       ├── widgets/
    │       └── bloc/
    │
    └── shared/              # Shared Features
        └── widgets/         # Widgets مشتركة بين Features
```

## المميزات

- ✅ Clean Architecture
- ✅ Dio للشبكة (Network)
- ✅ Dependency Injection (GetIt + Injectable)
- ✅ Error Handling
- ✅ Result Pattern
- ✅ جاهز لإضافة Features جديدة

## كيفية الاستخدام

### 1. تثبيت Dependencies

```bash
flutter pub get
```

### 2. تشغيل Code Generation (لـ Injectable)

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 3. إضافة Feature جديدة

كل feature له بنية مستقلة تحتوي على data, domain, presentation.

راجع `lib/features/README.md` لمثال كامل ومفصل.

#### مثال سريع: إضافة User Feature

1. إنشاء البنية:
```
lib/features/users/
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

2. اتبع نفس النمط الموجود في `features/home/` كمرجع

3. **Register في DI:**
   - إضافة `@injectable` annotation للـ classes
   - تشغيل `build_runner` مرة أخرى

### 4. إضافة Endpoint جديد

1. إضافة الـ endpoint في `lib/core/network/endpoints.dart`:
```dart
class Endpoints {
  static const String users = '/users';
}
```

2. استخدامه في Data Source:
```dart
final response = await apiClient.get(Endpoints.users);
```

## Dependencies المستخدمة

- `dio`: للشبكة (HTTP Client)
- `get_it`: Dependency Injection Container
- `injectable`: Code Generation للـ DI
- `flutter_bloc`: State Management
- `equatable`: للمقارنة بين Objects
- `freezed`: Code Generation للـ Models
- `json_annotation`: JSON Serialization

## ملاحظات

- ✅ **Feature-Based Structure**: كل feature مستقل تماماً
- ✅ **Core Layer**: مشترك بين كل الـ features
- ✅ **Base Classes**: موجودة في `core/base/` للاستخدام من أي feature
- الـ base URL موجود في `lib/core/constants/api_constants.dart`
- يمكن إضافة Authentication Token في `ApiClient` interceptors
- الـ endpoints ستُضاف لاحقاً حسب الحاجة
- راجع `lib/features/README.md` لدليل كامل لإضافة features جديدة
