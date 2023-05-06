import 'package:flutter/material.dart';

class AppColors {
  static get neutralGrey900 => const Color(0xff141C24);
  static get neutralGrey800 => const Color(0xff202B37);
  static get neutralGrey700 => const Color(0xff344051);
  static get neutralGrey600 => const Color(0xff414E62);
  static get neutralGrey500 => const Color(0xff637083);
  static get neutralGrey400 => const Color(0xff97A1AF);
  static get neutralGrey300 => const Color(0xffCED2DA);
  static get neutralGrey200 => const Color(0xffE4E7EC);
  static get neutralGrey100 => const Color(0xffF2F4F7);
  static get neutralGrey50 => const Color(0xffF9FAFB);

  static get alertRed => const Color(0xffF20D0D);

  static get buttonColor => const Color(0xff1A75FF);
  static get buttonColorDisabled => const Color(0xffCCE0FF);
  static get blue200 => const Color(0xff99C2FF);
  static get blue300 => const Color(0xff7FB2FF);

  static get appBarGradient => const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: <Color>[Color.fromARGB(255, 52, 64, 84), Color(0xff475467)]);
}
