import 'package:attendance_app_v2/helpers/colors.dart';
import 'package:attendance_app_v2/helpers/fonts.dart';
import 'package:attendance_app_v2/helpers/screenDetails.dart';
import 'package:attendance_app_v2/modules/screenHome.dart';
import 'package:attendance_app_v2/modules/screenRegister.dart';

import 'package:attendance_app_v2/widgets/customButtons.dart';
import 'package:attendance_app_v2/widgets/customTextFields.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';

class ScreenLogin extends StatefulWidget {
  static String route = '/screen-login';
  const ScreenLogin({super.key});

  @override
  State<ScreenLogin> createState() => _ScreenLoginState();
}

class _ScreenLoginState extends State<ScreenLogin> {
  late TextEditingController _controllerEmail;
  late TextEditingController _controllerPassword;
  bool _obscureTextPassword = false;
  @override
  void initState() {
    super.initState();
    _controllerEmail = TextEditingController();
    _controllerPassword = TextEditingController();
  }

  @override
  void dispose() {
    _controllerEmail.dispose();
    _controllerPassword.dispose();
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
            height: context.height(350),
            fit: BoxFit.fitHeight,
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
              SizedBox(
                height: context.height(24),
              ),
              Row(
                children: [
                  CustomButtons(
                    text: 'Login',
                    onTap: () {
                      Navigator.of(context).pushNamed(ScreenHome.route);
                    },
                    buttonWidth: ButtonWidth.max,
                    buttonSize: ButtonSize.large,
                  ),
                  const SizedBox(width: 12),
                  CustomButtons(
                    text: 'Register',
                    onTap: () {
                      Navigator.of(context)
                          .pushReplacementNamed(ScreenRegister.route);
                    },
                    buttonVarient: ButtonVarient.outlined,
                    buttonSize: ButtonSize.large,
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
