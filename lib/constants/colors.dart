import 'package:flutter/material.dart';

Color kBackground = const Color(0xFF120918);
Color kContrast = const Color(0xFF201726);
Color kBlack = const Color(0xFF07080c);
Color kWhite = const Color(0xFFe6e8f0);
Color kBlue = const Color(0xFF4b51e8);
Color kViolet = const Color(0xFF7655fa);
Color kPink = const Color(0xFFff1d72);
Color kGray = const Color(0xFFb5b6ba);

// radial-gradient(ellipse at var(--gradient-pos, top) center, rgba(210, 30, 246, .5), transparent 80%);
// using the commented radial-gradient

List<Color> kGradient = [
  const Color.fromARGB(210, 30, 246, 210),
  const Color.fromARGB(0, 210, 30, 246),
  const Color.fromARGB(210, 210, 30, 246),
  const Color.fromARGB(0, 210, 210, 30),
  const Color.fromARGB(210, 210, 210, 30),
];
