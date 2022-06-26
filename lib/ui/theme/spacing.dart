import 'package:flutter/material.dart';

abstract class Spacing {
  static const padding = 2.0;
  static const width = 2.0;
  static const height = 2.0;

  static Widget w1 = const SizedBox(width: width);
  static Widget w2 = const SizedBox(width: width * 2);
  static Widget w3 = const SizedBox(width: width * 3);
  static Widget w4 = const SizedBox(width: width * 4);
  static Widget w6 = const SizedBox(width: width * 6);
  static Widget w8 = const SizedBox(width: width * 8);

  static Widget h1 = const SizedBox(height: height);
  static Widget h2 = const SizedBox(height: height * 2);
  static Widget h3 = const SizedBox(height: height * 3);
  static Widget h4 = const SizedBox(height: height * 4);
  static Widget h6 = const SizedBox(height: height * 6);
  static Widget h8 = const SizedBox(height: height * 8);

  static EdgeInsets p1 = const EdgeInsets.all(padding);
  static EdgeInsets p2 = const EdgeInsets.all(padding * 2);
  static EdgeInsets p3 = const EdgeInsets.all(padding * 3);
  static EdgeInsets p4 = const EdgeInsets.all(padding * 4);
  static EdgeInsets p6 = const EdgeInsets.all(padding * 6);
  static EdgeInsets p8 = const EdgeInsets.all(padding * 8);

  static EdgeInsets px1 = const EdgeInsets.symmetric(horizontal: padding);
  static EdgeInsets px2 = const EdgeInsets.symmetric(horizontal: padding * 2);
  static EdgeInsets px3 = const EdgeInsets.symmetric(horizontal: padding * 3);
  static EdgeInsets px4 = const EdgeInsets.symmetric(horizontal: padding * 4);
  static EdgeInsets px6 = const EdgeInsets.symmetric(horizontal: padding * 5);
  static EdgeInsets px8 = const EdgeInsets.symmetric(horizontal: padding * 6);

  static EdgeInsets py1 = const EdgeInsets.symmetric(vertical: padding);
  static EdgeInsets py2 = const EdgeInsets.symmetric(vertical: padding * 2);
  static EdgeInsets py3 = const EdgeInsets.symmetric(vertical: padding * 3);
  static EdgeInsets py4 = const EdgeInsets.symmetric(vertical: padding * 4);
  static EdgeInsets py6 = const EdgeInsets.symmetric(vertical: padding * 5);
  static EdgeInsets py8 = const EdgeInsets.symmetric(vertical: padding * 6);

  static BorderRadius rounded = BorderRadius.circular(10);
}
