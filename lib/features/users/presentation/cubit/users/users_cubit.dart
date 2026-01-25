import 'package:flutter_app/features/users/domain/entities/user.dart';
import 'package:flutter_app/features/users/domain/usecases/get_users.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/utils/result.dart';
import 'users_state.dart';

class UsersCubit extends Cubit<UsersState> {
  final GetUsers getUsers;

  UsersCubit(this.getUsers) : super(UsersInitial());

  Future<void> getUsersList() async {
    emit(UsersLoading());
    final result = await getUsers();
    if (result is Success<List<User>>) {
      emit(UsersLoaded(result.data));
    } else if (result is Error<List<User>>) {
      emit(UsersError(result.failure));
    }
  }
}

