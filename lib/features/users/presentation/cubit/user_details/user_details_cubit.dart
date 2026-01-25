import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_user_by_id.dart';
import '../../../domain/entities/user.dart';
import '../../../../../core/utils/result.dart';
import 'user_details_state.dart';

class UserDetailsCubit extends Cubit<UserDetailsState> {
  final GetUserById getUserById;

  UserDetailsCubit(this.getUserById) : super(UserDetailsInitial());

  Future<void> getUser(int userId) async {
    emit(UserDetailsLoading());
    final result = await getUserById(userId);
    if (result is Success<User>) {
      emit(UserDetailsLoaded(result.data));
    } else if (result is Error<User>) {
      emit(UserDetailsError(result.failure));
    }
  }
}

