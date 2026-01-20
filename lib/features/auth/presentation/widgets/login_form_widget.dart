import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:propertybooking/features/auth/presentation/manager/auth_cubit/auth_cubit_cubit.dart';
import 'package:propertybooking/l10n/app_localizations.dart';
import 'package:propertybooking/features/auth/presentation/widgets/custom_login_text_field.dart';
import 'package:propertybooking/features/auth/presentation/widgets/custom_login_button.dart';
import 'package:provider/provider.dart';

class LoginFormWidget extends StatefulWidget {
  const LoginFormWidget({super.key});

  @override
  State<LoginFormWidget> createState() => _LoginFormWidgetState();
}

class _LoginFormWidgetState extends State<LoginFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final _userCodeController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _userCodeController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      // setState(() {
      //   _isLoading = true;
      // });

      // // TODO: Implement actual login logic
      // Future.delayed(const Duration(seconds: 2), () {
      //   if (mounted) {
      //     setState(() {
      //       _isLoading = false;
      //     });
      //   }
      // });
      context.read<AuthCubitCubit>().getUser(
        int.parse(_userCodeController.text),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // User Code Field
          CustomLoginTextField(
            controller: _userCodeController,
            label: l10n.userCode,
            hint: l10n.userCodeHint,
            icon: Icons.person_outline,
            keyboardType: TextInputType.text,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return l10n.userCodeRequired;
              }
              return null;
            },
          ),

          SizedBox(height: 20.h),

          // Password Field
          CustomLoginTextField(
            controller: _passwordController,
            label: l10n.password,
            hint: l10n.passwordHint,
            icon: Icons.lock_outline,
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return l10n.passwordRequired;
              }
              return null;
            },
          ),

          SizedBox(height: 32.h),

          // Login Button
          CustomLoginButton(
            text: l10n.loginButton,
            onPressed: _handleLogin,
            isLoading: _isLoading,
          ),
        ],
      ),
    );
  }
}
