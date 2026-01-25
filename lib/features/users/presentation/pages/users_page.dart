import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection_container.dart';
import '../cubit/users/users_cubit.dart';
import '../cubit/users/users_state.dart';
import '../../../../features/shared/widgets/loading_widget.dart';
import '../../../../features/shared/widgets/error_widget.dart';
import '../widgets/user_card.dart';
import 'user_details_page.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<UsersCubit>()..getUsersList(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('users'),
          centerTitle: true,
        ),
        body: BlocBuilder<UsersCubit, UsersState>(
          builder: (context, state) {
            if (state is UsersLoading) {
              return const LoadingWidget();
            } else if (state is UsersError) {
              return ErrorMessageWidget(
                failure: state.failure,
                onRetry: () {
                  context.read<UsersCubit>().getUsersList();
                },
              );
            } else if (state is UsersLoaded) {
              return GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  childAspectRatio: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: state.users.length,
                itemBuilder: (context, index) {
                  final user = state.users[index];
                  return UserCard(
                    user: user,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserDetailsPage(
                            userId: user.id,
                          ),
                        ),
                      );
                    },
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

