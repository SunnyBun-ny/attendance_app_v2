import 'package:attendance_app_v2/helpers/screenDetails.dart';

import 'package:attendance_app_v2/modules/screenLogin.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  bool _enabledEmail = true;
  bool _enabledPass = true;
  bool _enabledConfirmPass = true;
  bool _isLoadingRegister = false;
  String? _errorEmail;
  String? _errorPass;
  String? _errorCPass;
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
          backgroundColor: Colors.white,
          body: Container(
            alignment: Alignment.topCenter,
            decoration: const BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fitWidth,
                alignment: Alignment.topCenter,
                image: AssetImage(
                  'assets/images/login_vector.png',
                ),
              ),
            ),
          ),
          bottomSheet: Container(
            padding: EdgeInsets.symmetric(
                horizontal: context.width(20), vertical: context.height(32)),
            decoration: BoxDecoration(
                color: AppColors.neutralGrey200,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20))),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
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
                enabled: _enabledEmail,
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
                enabled: _enabledPass,
                errorText: _errorPass,
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
                enabled: _enabledConfirmPass,
                errorText: _errorCPass,
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
                    onTap: _onTapRegister,
                    buttonSize: ButtonSize.large,
                    buttonWidth: ButtonWidth.max,
                    isLoading: _isLoadingRegister,
                  )
                ],
              ),
            ]),
          )),
    );
  }

  void _onTapRegister() async {
    setState(() {
      _isLoadingRegister = true;
      _enabledConfirmPass = false;
      _enabledEmail = false;
      _enabledPass = false;
      _errorCPass = null;
      _errorEmail = null;
      _errorPass = null;
    });

    if (_controllerEmail.text.isEmpty) {
      setState(() {
        _errorEmail = 'Please enter valid email';
      });
    } else if (_controllerPassword.text.isEmpty) {
      setState(() {
        _errorPass = 'Please enter password';
      });
    } else if (_controllerConfirmPassword.text.isEmpty) {
      setState(() {
        _errorCPass = 'Please enter confimr password';
      });
    } else if (_controllerPassword.text.trim() !=
        _controllerConfirmPassword.text.trim()) {
      setState(() {
        _errorCPass = 'Password and Confirm Password do not match.';
      });
    } else {
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _controllerEmail.text.trim(),
          password: _controllerConfirmPassword.text.trim(),
        );
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Registration Successful!!')));
        Navigator.of(context).pushReplacementNamed(ScreenLogin.route);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'invalid-email') {
          _errorEmail = 'Please enter valid email';
          print('Invalid email');
        } else if (e.code == 'weak-password') {
          _errorPass = 'Password too weak';
          print('The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          _errorEmail = 'Email already in use. Try Login.';
          print('The account already exists for that email.');
        } else {
          print('unknown error');
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('Unknown Erro')));
        }
        setState(() {
          _isLoadingRegister = false;
          _enabledConfirmPass = true;
          _enabledEmail = true;
          _enabledPass = true;
        });
      }
    }

    setState(() {
      _isLoadingRegister = false;
      _enabledConfirmPass = true;
      _enabledEmail = true;
      _enabledPass = true;
    });
  }
}
