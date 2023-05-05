import 'package:flutter/material.dart';

extension DeviceSize on BuildContext {
  height(int size) => MediaQuery.of(this).size.height * size / 800;
  width(int size) => MediaQuery.of(this).size.width * size / 360;
}
