# Clean Architecture Guide

## مثال: إضافة User Feature

### 1. Domain Layer (Business Logic)

#### Entity
```dart
// lib/domain/entities/user.dart
import 'package:equatable/equatable.dart';
import 'base_entity.dart';

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
// lib/domain/repositories/user_repository.dart
import '../entities/user.dart';
import '../../core/utils/result.dart';
import 'base_repository.dart';

abstract class UserRepository extends BaseRepository {
  Future<Result<List<User>>> getUsers();
  Future<Result<User>> getUserById(int id);
}
```

#### Use Case
```dart
// lib/domain/usecases/get_users.dart
import 'package:injectable/injectable.dart';
import '../entities/user.dart';
import '../repositories/user_repository.dart';
import '../../core/utils/result.dart';
import 'base_usecase.dart';

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

### 2. Data Layer

#### Model
```dart
// lib/data/models/user_model.dart
import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/user.dart';
import 'base_model.dart';

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
// lib/data/data_sources/user_remote_data_source.dart
import 'package:injectable/injectable.dart';
import '../../core/network/api_client.dart';
import '../../core/network/endpoints.dart';
import '../../core/errors/exceptions.dart';
import '../models/user_model.dart';
import 'remote_data_source.dart';

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
// lib/data/repositories/user_repository_impl.dart
import 'package:injectable/injectable.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../../core/utils/result.dart';
import '../data_sources/user_remote_data_source.dart';
import '../models/user_model.dart';
import 'base_repository_impl.dart';

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

### 3. Presentation Layer

#### BLoC
```dart
// lib/presentation/bloc/users/users_bloc.dart
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
// lib/presentation/pages/users_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/users/users_bloc.dart';
import '../widgets/loading_widget.dart';
import '../widgets/error_widget.dart';

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

### 4. Register في DI

بعد إضافة `@injectable` annotations، قم بتشغيل:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

سيتم إنشاء `injection_container.config.dart` تلقائياً.

### 5. إضافة Endpoint

في `lib/core/network/endpoints.dart`:
```dart
class Endpoints {
  static const String users = '/users';
  static const String userById = '/users/{id}';
}
```

## ملاحظات مهمة

1. **Domain Layer** لا يعتمد على أي layer آخر
2. **Data Layer** يعتمد على Domain Layer فقط
3. **Presentation Layer** يعتمد على Domain Layer فقط
4. استخدم `Result<T>` للتعامل مع Success/Error
5. استخدم `@injectable` للـ classes التي تحتاج DI
6. استخدم `@Injectable(as: Interface)` للـ implementations

