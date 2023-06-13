import 'package:flutter/material.dart';

// Sombreado de los contenedores
myBoxShadow() {
  return [
    BoxShadow(
      color: Colors.black.withOpacity(0.2),
      spreadRadius: 7,
      blurRadius: 0,
    )
  ];
}
