import 'package:flutter/material.dart';

class TypeColors {
  static const Color grass = Color(0xFF4CAF50);
  static const Color water = Color(0xFF2196F3);
  static const Color fire = Color(0xFFF44336);
  static const Color electric = Color(0xFFFFC107);
  static const Color ground = Color(0xFF9E9E9E);
  static const Color rock = Color(0xFF795548);
  static const Color fairy = Color(0xFFFFC0CB);
  static const Color poison = Color(0xFF9C27B0);
  static const Color bug = Color(0xFF4CAF50);
  static const Color psychic = Color(0xFFF44336);
  static const Color flying = Color(0xFF2196F3);
  static const Color fighting = Color(0xFFF44336);
  static const Color ghost = Color(0xFF9E9E9E);
  static const Color dragon = Color(0xFF795548);
  static const Color dark = Color(0xFF9E9E9E);
  static const Color steel = Color(0xFF795548);
  static const Color normal = Color(0xFF9E9E9E);
  static const Color unknown = Color(0xFF9E9E9E);
  static const Color shadow = Color(0xFF9E9E9E);

  static Color getColor(String type) {
    switch (type) {
      case 'grass':
        return grass;
      case 'water':
        return water;
      case 'fire':
        return fire;
      case 'electric':
        return electric;
      case 'ground':
        return ground;
      case 'rock':
        return rock;
      case 'fairy':
        return fairy;
      case 'poison':
        return poison;
      case 'bug':
        return bug;
      case 'psychic':
        return psychic;
      case 'flying':
        return flying;
      case 'fighting':
        return fighting;
      case 'ghost':
        return ghost;
      case 'dragon':
        return dragon;
      case 'dark':
        return dark;
      case 'steel':
        return steel;
      case 'normal':
        return normal;
      case 'unknown':
        return unknown;
      case 'shadow':
        return shadow;
      default:
        return unknown;
    }
  }
}
