import 'package:bloc/bloc.dart';
import 'package:propertybooking/core/utils/enums/enums_state.dart';
import 'package:propertybooking/features/auth/data/models/user_model.dart';
import 'package:propertybooking/features/auth/data/repos/auth_repo.dart';
part 'auth_cubit_state.dart';

class AuthCubitCubit extends Cubit<AuthCubitState> {
  AuthCubitCubit(this.authRepo) : super(AuthCubitState());

  final AuthRepo authRepo;

  Future<void> validateAndLogin(int userCode, String password) async {
    emit(state.copyWith(loginState: EnumState.loading));
    final result = await authRepo.getUser(userCode);
    result.fold(
      (failure) {
        emit(state.copyWith(loginState: EnumState.failure));
      },
      (userModel) {
        // Check if items list is empty (user not found)
        if (userModel.items == null || userModel.items!.isEmpty) {
          emit(
            state.copyWith(
              loginState: EnumState.failure,
              errMessege: 'userNotFound',
            ),
          );
          return;
        }

        // Get the password from the response
        final apiPassword = userModel.items![0].password;

        // Validate password
        if (apiPassword != password) {
          emit(
            state.copyWith(
              loginState: EnumState.failure,
              errMessege: 'invalidPassword',
            ),
          );
          return;
        }

        // Password is correct, proceed with login
        emit(
          state.copyWith(
            loginState: EnumState.success,
            userModel: userModel,
            errMessege: null,
          ),
        );

        // Call postActivity after successful login
        postActivity(userModel.items![0].empCode ?? 0);
      },
    );
  }

  Future<void> getUser(int userCode) async {
    emit(state.copyWith(loginState: EnumState.loading));
    final result = await authRepo.getUser(userCode);
    result.fold(
      (failure) {
        emit(state.copyWith(loginState: EnumState.failure));
      },
      (userModel) {
        emit(
          state.copyWith(loginState: EnumState.success, userModel: userModel),
        );
      },
    );
  }

  Future<void> postActivity(int userCode) async {
    emit(state.copyWith(postActivityState: EnumState.loading));
    await authRepo.postActivity(userCode);
    emit(state.copyWith(postActivityState: EnumState.success));
  }
}
