import 'package:attendance_app_v2/helpers/colors.dart';
import 'package:attendance_app_v2/helpers/fonts.dart';
import 'package:attendance_app_v2/helpers/screenDetails.dart';
import 'package:attendance_app_v2/modules/screenHome.dart';
import 'package:attendance_app_v2/modules/screenRegister.dart';

import 'package:attendance_app_v2/widgets/customButtons.dart';
import 'package:attendance_app_v2/widgets/customTextFields.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  bool _enableEmailField = true;
  bool _enablePasswordField = true;
  bool _isLoading = false;
  String? _errorEmail;
  String? _errorPass;
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
          backgroundColor: Colors.white,
          body: Column(mainAxisSize: MainAxisSize.max, children: [
            Image.asset(
              'assets/images/login_vector.png',
              height: context.height(350),
              fit: BoxFit.fill,
            ),
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: context.width(20), vertical: context.height(32)),
              decoration: BoxDecoration(
                  color: AppColors.neutralGrey200,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(20))),
              child: Column(mainAxisSize: MainAxisSize.max, children: [
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
                  enabled: _enableEmailField,
                  errorText: _errorEmail,
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
                  enabled: _enablePasswordField,
                  errorText: _errorPass,
                ),
                SizedBox(
                  height: context.height(24),
                ),
                Row(
                  children: [
                    CustomButtons(
                      text: 'Login',
                      onTap: _onTapLogin,
                      buttonWidth: ButtonWidth.max,
                      buttonSize: ButtonSize.large,
                      isLoading: _isLoading,
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
          ])),
    );
  }

  void _onTapLogin() async {
    setState(() {
      _enableEmailField = false;
      _enablePasswordField = false;
      _isLoading = true;
      _errorEmail = null;
      _errorPass = null;
    });
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _controllerEmail.text.trim(),
        password: _controllerPassword.text.trim(),
      );
      Navigator.of(context).pushReplacementNamed(ScreenHome.route);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No user found for that email.')));
        print('No user found for that email.');
      } else if (e.code == 'invalid-email') {
        setState(() {
          _errorEmail = 'Please eneter correct email id';
        });
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Wrong password provided for that user.')));
        print('Wrong password provided for that user.');
      } else {
        print(e.code);
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Network Error')));
      }
      setState(() {
        _enableEmailField = true;
        _enablePasswordField = true;
        _isLoading = false;
      });
    }
  }

  bool _emailValid(String email) => RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(email);
}
