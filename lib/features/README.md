# Features Structure

كل feature له بنية مستقلة تحتوي على:

```
features/
├── feature_name/
│   ├── data/                    # Data Layer
│   │   ├── data_sources/        # Remote & Local Data Sources
│   │   ├── models/              # Data Models
│   │   └── repositories/        # Repository Implementations
│   │
│   ├── domain/                  # Domain Layer
│   │   ├── entities/            # Domain Entities
│   │   ├── repositories/         # Repository Interfaces
│   │   └── usecases/             # Use Cases
│   │
│   └── presentation/             # Presentation Layer
│       ├── pages/                # Screens/Pages
│       ├── widgets/              # Feature-specific Widgets
│       └── bloc/                 # State Management (BLoC)
│
└── shared/                       # Shared Features
    └── widgets/                  # Shared Widgets across features
```

## مثال: إضافة Feature جديد (مثلاً Users)

### 1. إنشاء البنية الأساسية

```
features/
└── users/
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

### 2. Domain Layer

#### Entity
```dart
// features/users/domain/entities/user.dart
import 'package:equatable/equatable.dart';
import '../../../../core/base/base_entity.dart';

class User extends BaseEntity {
  final int id;
  final String name;
  final String email;

  const User({
    required this.id,
    required this.name,
    required this.email,
  });

  @override
  List<Object> get props => [id, name, email];
}
```

#### Repository Interface
```dart
// features/users/domain/repositories/user_repository.dart
import '../../../../core/base/base_repository.dart';
import '../../../../core/utils/result.dart';
import '../entities/user.dart';

abstract class UserRepository extends BaseRepository {
  Future<Result<List<User>>> getUsers();
  Future<Result<User>> getUserById(int id);
}
```

#### Use Case
```dart
// features/users/domain/usecases/get_users.dart
import 'package:injectable/injectable.dart';
import '../../../../core/base/base_usecase.dart';
import '../../../../core/utils/result.dart';
import '../entities/user.dart';
import '../repositories/user_repository.dart';

@injectable
class GetUsers implements UseCaseNoParams<List<User>> {
  final UserRepository repository;

  GetUsers(this.repository);

  @override
  Future<Result<List<User>>> call() {
    return repository.getUsers();
  }
}
```

### 3. Data Layer

#### Model
```dart
// features/users/data/models/user_model.dart
import 'package:json_annotation/json_annotation.dart';
import '../../../../core/base/base_model.dart';
import '../../domain/entities/user.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel extends BaseModel<User> {
  final int id;
  final String name;
  final String email;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  @override
  User toEntity() {
    return User(
      id: id,
      name: name,
      email: email,
    );
  }
}
```

#### Remote Data Source
```dart
// features/users/data/data_sources/user_remote_data_source.dart
import 'package:injectable/injectable.dart';
import '../../../../core/base/base_data_source.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/endpoints.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/user_model.dart';

@injectable
class UserRemoteDataSource extends RemoteDataSource {
  UserRemoteDataSource(super.apiClient);

  Future<List<UserModel>> getUsers() async {
    try {
      final response = await apiClient.get(Endpoints.users);
      final List<dynamic> data = response.data;
      return data.map((json) => UserModel.fromJson(json)).toList();
    } catch (e) {
      throw ServerException('Failed to get users');
    }
  }
}
```

#### Repository Implementation
```dart
// features/users/data/repositories/user_repository_impl.dart
import 'package:injectable/injectable.dart';
import '../../../../core/base/base_repository_impl.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../../../../core/utils/result.dart';
import '../data_sources/user_remote_data_source.dart';
import '../models/user_model.dart';

@Injectable(as: UserRepository)
class UserRepositoryImpl extends BaseRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;

  UserRepositoryImpl(this.remoteDataSource);

  @override
  Future<Result<List<User>>> getUsers() async {
    try {
      final models = await remoteDataSource.getUsers();
      final entities = models.map((model) => model.toEntity()).toList();
      return Success(entities);
    } catch (e) {
      return handleError(e);
    }
  }

  @override
  Future<Result<User>> getUserById(int id) async {
    // Implementation here
    throw UnimplementedError();
  }
}
```

### 4. Presentation Layer

#### BLoC
```dart
// features/users/presentation/bloc/users/users_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/get_users.dart';

part 'users_event.dart';
part 'users_state.dart';

class UsersBloc extends Bloc<UsersEvent, UsersState> {
  final GetUsers getUsers;

  UsersBloc(this.getUsers) : super(UsersInitial()) {
    on<GetUsersEvent>(_onGetUsers);
  }

  Future<void> _onGetUsers(
    GetUsersEvent event,
    Emitter<UsersState> emit,
  ) async {
    emit(UsersLoading());
    final result = await getUsers();
    result.fold(
      (failure) => emit(UsersError(failure.message)),
      (users) => emit(UsersLoaded(users)),
    );
  }
}
```

#### Page
```dart
// features/users/presentation/pages/users_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/di/injection_container.dart';
import '../bloc/users/users_bloc.dart';
import '../../../../features/shared/widgets/loading_widget.dart';
import '../../../../features/shared/widgets/error_widget.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<UsersBloc>()..add(GetUsersEvent()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Users')),
        body: BlocBuilder<UsersBloc, UsersState>(
          builder: (context, state) {
            if (state is UsersLoading) {
              return const LoadingWidget();
            } else if (state is UsersError) {
              return ErrorMessageWidget(failure: state.failure);
            } else if (state is UsersLoaded) {
              return ListView.builder(
                itemCount: state.users.length,
                itemBuilder: (context, index) {
                  final user = state.users[index];
                  return ListTile(
                    title: Text(user.name),
                    subtitle: Text(user.email),
                  );
                },
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
```

## ملاحظات مهمة

1. كل feature مستقل تماماً
2. Core layer مشترك بين كل الـ features
3. Shared widgets في `features/shared/widgets/`
4. استخدم `@injectable` للـ classes التي تحتاج DI
5. بعد إضافة `@injectable` annotations، قم بتشغيل:
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

