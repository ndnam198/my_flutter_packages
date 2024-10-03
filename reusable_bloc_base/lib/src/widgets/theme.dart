import 'package:flutter/material.dart';

const gapH12 = SizedBox(height: Sizes.p12);

const gapH16 = SizedBox(height: Sizes.p16);

const gapH20 = SizedBox(height: Sizes.p20);
const gapH24 = SizedBox(height: Sizes.p24);
const gapH32 = SizedBox(height: Sizes.p32);

/// Constant gap heights
const gapH4 = SizedBox(height: Sizes.p4);

const gapH48 = SizedBox(height: Sizes.p48);
const gapH64 = SizedBox(height: Sizes.p64);
const gapH8 = SizedBox(height: Sizes.p8);
const gapW10 = SizedBox(width: Sizes.p10);
const gapW12 = SizedBox(width: Sizes.p12);
const gapW16 = SizedBox(width: Sizes.p16);

/// Constant gap widths
const gapW2 = SizedBox(width: Sizes.p2);

const gapW20 = SizedBox(width: Sizes.p20);
const gapW24 = SizedBox(width: Sizes.p24);
const gapW32 = SizedBox(width: Sizes.p32);
const gapW4 = SizedBox(width: Sizes.p4);
const gapW48 = SizedBox(width: Sizes.p48);
const gapW5 = SizedBox(width: Sizes.p5);
const gapW64 = SizedBox(width: Sizes.p64);
const gapW8 = SizedBox(width: Sizes.p8);

class AC {
  static const error = Color.fromRGBO(236, 29, 36, 1);
  static const disable = Color.fromARGB(20, 0, 0, 0);
  static const primary = Color(0xFF9F1D15);
  static const shadow = Color.fromRGBO(0, 0, 0, 0.1);
  static final lightGrey = Colors.black.withOpacity(.05);
  static const white_9 = Color.fromRGBO(255, 255, 255, 0.9);
  static const success = Colors.green;
  static final scaffold = Colors.white.withOpacity(.8);
  static final barrier = Colors.black.withOpacity(.5);
  static const black33 = Color(0xff333333);
  static const lightBlack = Color(0xff666666);
}

class AD {
  static const insetPadding = EdgeInsets.all(Sizes.p16);
}

class Paddings {
  static const dialog = EdgeInsets.symmetric(vertical: 16, horizontal: 24);
}

/// Constant sizes to be used in the app (paddings, gaps, rounded corners etc.)
class Sizes {
  static const p2 = 2.0;
  static const p4 = 4.0;
  static const p5 = 5.0;
  static const p8 = 8.0;
  static const p10 = 10.0;
  static const p12 = 12.0;
  static const p16 = 16.0;
  static const p20 = 20.0;
  static const p24 = 24.0;
  static const p32 = 32.0;
  static const p48 = 48.0;
  static const p56 = 56.0;
  static const p64 = 64.0;
}
