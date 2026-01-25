import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_app/features/users/presentation/cubit/user_details/user_details_cubit.dart';
import 'package:flutter_app/features/users/presentation/cubit/user_details/user_details_state.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../features/shared/widgets/loading_widget.dart';
import '../../../../features/shared/widgets/error_widget.dart';
import '../widgets/user_details_view.dart';

class UserDetailsPage extends StatelessWidget {
  final int userId;

  const UserDetailsPage({
    super.key,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<UserDetailsCubit>()..getUser(userId),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('User Details'),
        ),
        body: BlocBuilder<UserDetailsCubit, UserDetailsState>(
          builder: (context, state) {
            if (state is UserDetailsLoading) {
              return const LoadingWidget();
            }
            else if (state is UserDetailsError) {
              return ErrorMessageWidget(
                failure: state.failure,
                onRetry: () {
                  context.read<UserDetailsCubit>().getUser(userId);
                },
              );
            }
            else if (state is UserDetailsLoaded) {
              return UserDetailsView(user: state.user);
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}