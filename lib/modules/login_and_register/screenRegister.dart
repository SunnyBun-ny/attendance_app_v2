import 'package:attendance_app_v2/helpers/screenDetails.dart';
import 'package:attendance_app_v2/modules/login_and_register/screenLogin.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';

import '../../helpers/colors.dart';
import '../../helpers/fonts.dart';
import '../../widgets/customButtons.dart';
import '../../widgets/customTextFields.dart';

class ScreenRegister extends StatefulWidget {
  static String route = '/screen-register';
  const ScreenRegister({super.key});

  @override
  State<ScreenRegister> createState() => _ScreenRegisterState();
}

class _ScreenRegisterState extends State<ScreenRegister> {
  late TextEditingController _controllerEmail;
  late TextEditingController _controllerPassword;
  late TextEditingController _controllerConfirmPassword;
  bool _obscureTextPassword = false;
  bool _obscureTextConfirmPassword = false;
  @override
  void initState() {
    super.initState();
    _controllerEmail = TextEditingController();
    _controllerPassword = TextEditingController();
    _controllerConfirmPassword = TextEditingController();
  }

  @override
  void dispose() {
    _controllerEmail.dispose();
    _controllerPassword.dispose();
    _controllerConfirmPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: SingleChildScrollView(
        child: Column(children: [
          Image.asset(
            'assets/images/login_vector.png',
            height: context.height(270),
            fit: BoxFit.fitWidth,
          ),
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: context.width(20), vertical: context.height(32)),
            decoration: BoxDecoration(
                color: AppColors.neutralGrey200,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20))),
            child: Column(children: [
              Text(
                'Attendance App',
                style: CustomFontStyle.h3Semi(
                  AppColors.neutralGrey700,
                ),
                softWrap: true,
              ),
              SizedBox(
                height: context.height(20),
              ),
              CustomTextfields(
                controller: _controllerEmail,
                labelText: 'Email',
                hintText: 'Enter your email',
                prefixIcon: BootstrapIcons.person_fill,
                suffixIcon: BootstrapIcons.x,
                onTapSuffixIcon: () => _controllerEmail.clear(),
              ),
              const SizedBox(height: 8),
              CustomTextfields(
                controller: _controllerPassword,
                labelText: 'Password',
                hintText: 'Enter password',
                prefixIcon: BootstrapIcons.lock_fill,
                suffixIcon: !_obscureTextPassword
                    ? BootstrapIcons.eye_slash_fill
                    : BootstrapIcons.eye_fill,
                obscureText: _obscureTextPassword,
                onTapSuffixIcon: () {
                  setState(() {
                    _obscureTextPassword
                        ? _obscureTextPassword = false
                        : _obscureTextPassword = true;
                  });
                },
              ),
              const SizedBox(height: 8),
              CustomTextfields(
                controller: _controllerConfirmPassword,
                labelText: 'Confirm Password',
                hintText: 'Confirm password',
                prefixIcon: BootstrapIcons.lock_fill,
                suffixIcon: !_obscureTextConfirmPassword
                    ? BootstrapIcons.eye_slash_fill
                    : BootstrapIcons.eye_fill,
                obscureText: _obscureTextConfirmPassword,
                onTapSuffixIcon: () {
                  setState(() {
                    _obscureTextConfirmPassword
                        ? _obscureTextConfirmPassword = false
                        : _obscureTextConfirmPassword = true;
                  });
                },
              ),
              SizedBox(
                height: context.height(24),
              ),
              Row(
                children: [
                  CustomButtons(
                    text: 'Login',
                    onTap: () {
                      Navigator.of(context)
                          .pushReplacementNamed(ScreenLogin.route);
                    },
                    buttonVarient: ButtonVarient.outlined,
                    buttonWidth: ButtonWidth.min,
                    buttonSize: ButtonSize.large,
                  ),
                  const SizedBox(width: 12),
                  CustomButtons(
                    text: 'Register',
                    onTap: () {},
                    buttonSize: ButtonSize.large,
                    buttonWidth: ButtonWidth.max,
                  )
                ],
              ),
            ]),
          )
        ]),
      )),
    );
  }
}
