import 'package:flutter/material.dart';

myBoxShadow() {
  return [
    BoxShadow(
      color: Colors.black.withOpacity(0.4),
      spreadRadius: 10,
      blurRadius: 15,
      offset: const Offset(0, 3),
    )
  ];
}
