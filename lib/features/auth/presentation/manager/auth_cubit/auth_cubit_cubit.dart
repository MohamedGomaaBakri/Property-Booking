import 'package:bloc/bloc.dart';
import 'package:propertybooking/core/utils/enums/enums_state.dart';
import 'package:propertybooking/features/auth/data/models/user_model.dart';
import 'package:propertybooking/features/auth/data/repos/auth_repo.dart';
part 'auth_cubit_state.dart';

class AuthCubitCubit extends Cubit<AuthCubitState> {
  AuthCubitCubit(this.authRepo) : super(AuthCubitState());

  final AuthRepo authRepo;

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
        postActivity(userModel.items?[0].empCode ?? 0);
      },
    );
  }

  Future<void> postActivity(int userCode) async {
    emit(state.copyWith(postActivityState: EnumState.loading));
    await authRepo.postActivity(userCode);
    emit(state.copyWith(postActivityState: EnumState.success));
  }
}
