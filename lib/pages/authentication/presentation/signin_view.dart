import 'package:talent_mesh/common/app_enums.dart';
import 'package:talent_mesh/common/navigation/app_routes.dart';
import 'package:talent_mesh/common/navigation/routes.dart';
import 'package:talent_mesh/common/widgets/button/custom_button.dart';
import 'package:talent_mesh/common/widgets/textfield/custom_textfield_with_label.dart';
import 'package:talent_mesh/pages/authentication/domain/authentication_cubit.dart';
import 'package:talent_mesh/pages/authentication/domain/authentication_state.dart';
import 'package:talent_mesh/styles/app_colors.dart';
import 'package:talent_mesh/styles/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SigninView extends StatefulWidget {
  const SigninView({super.key});

  @override
  State<SigninView> createState() => _SigninViewState();
}

class _SigninViewState extends State<SigninView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passWordController = TextEditingController();
  late AuthenticationCubit _authenticationCubit;

  @override
  void initState() {
    super.initState();
    _authenticationCubit = context.read<AuthenticationCubit>();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passWordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hello\tTHERE.',
              style: AppTextStyles.heading1ExtraBold24(
                color: AppColors.primary,
              ),
            ),
            4.verticalSpace,
            Text(
              "Welcome back, let's get stared",
              style: AppTextStyles.heading1ExtraBold20(
                color: AppColors.primary,
              ),
            ),
            84.verticalSpace,

            //------Email
            CustomTextfieldWithLabel(
              isRequired: true,
              labelText: 'Email',
              hintText: 'Enter your email here',
              controller: _emailController,
              textInputAction: TextInputAction.next,
              textInputType: TextInputType.emailAddress,
              focusedBorderColor: AppColors.primary,
              cursorColor: AppColors.primary,
            ),
            16.verticalSpace,

            //-------Password
            CustomTextfieldWithLabel(
              isRequired: true,
              labelText: 'Password',
              hintText: 'Enter your password here',
              isPasswordFiled: true,
              controller: _passWordController,
              textInputAction: TextInputAction.done,
              focusedBorderColor: AppColors.primary,
              cursorColor: AppColors.primary,
            ),
            32.verticalSpace,

            //--------Login-Btn
            BlocBuilder<AuthenticationCubit, AuthenticationState>(
              builder: (context, state) {
                return CustomButton(
                  width: MediaQuery.sizeOf(context).width,
                  verticalPadding: 8.h,
                  horizontalPadding: 8.w,
                  wantBorder: false,
                  disableElevation: true,
                  isLoading: state.signinApiStatus == ApiStatus.loading,
                  buttonColor: AppColors.primary,
                  onPressed: () {
                    if (state.signinApiStatus != ApiStatus.loading) {
                      _authenticationCubit.signIn(
                        email: _emailController.text.trim(),
                        password: _passWordController.text.trim(),
                      );
                    }
                  },
                  child: Text(
                    'Login',
                    style: AppTextStyles.body2Medium16(
                      color: AppColors.surface,
                    ),
                  ),
                );
              },
            ),
            4.verticalSpace,

            //--------Sign-up
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don't have an account? ",
                  style: AppTextStyles.body3Regular14(),
                ),
                GestureDetector(
                  onTap: () {
                    AppRoutes.appRouter.push(
                      Routes.signup,
                    );
                  },
                  child: Text(
                    "Sign Up",
                    style: AppTextStyles.body3Medium14(
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
