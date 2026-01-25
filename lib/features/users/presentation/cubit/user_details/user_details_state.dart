import 'package:equatable/equatable.dart';
import '../../../domain/entities/user.dart';
import '../../../../../core/errors/failures.dart';

abstract class UserDetailsState extends Equatable {
  const UserDetailsState();

  @override
  List<Object> get props => [];
}

class UserDetailsInitial extends UserDetailsState {}

class UserDetailsLoading extends UserDetailsState {}

class UserDetailsLoaded extends UserDetailsState {
  final User user;

  const UserDetailsLoaded(this.user);

  @override
  List<Object> get props => [user];
}

class UserDetailsError extends UserDetailsState {
  final Failure failure;

  const UserDetailsError(this.failure);

  @override
  List<Object> get props => [failure];
}

