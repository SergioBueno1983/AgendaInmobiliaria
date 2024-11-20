import 'dart:io';

import 'package:flutter/material.dart';

class Plataforma extends StatelessWidget {
  final Widget Function(BuildContext) androidBuilder;
  final Widget Function(BuildContext) iOSBuilder;

  const Plataforma({
    Key? key,
    required this.androidBuilder,
    required this.iOSBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      return androidBuilder(context);
    } else {
      return iOSBuilder(context);
    }
  }
}