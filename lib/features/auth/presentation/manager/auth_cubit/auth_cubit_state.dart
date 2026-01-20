part of 'auth_cubit_cubit.dart';

class AuthCubitState {
  final UserModel? userModel;
  final String? errMessege;
  final EnumState? loginState;
  final EnumState? postActivityState;

  AuthCubitState({
    this.userModel,
    this.errMessege,
    this.loginState = EnumState.initial,
    this.postActivityState = EnumState.initial,
  });

  AuthCubitState copyWith({
    UserModel? userModel,
    String? errMessege,
    EnumState? loginState,
    EnumState? postActivityState,
  }) {
    return AuthCubitState(
      userModel: userModel ?? this.userModel,
      errMessege: errMessege ?? this.errMessege,
      loginState: loginState ?? this.loginState,
      postActivityState: postActivityState ?? this.postActivityState,
    );
  }
}
