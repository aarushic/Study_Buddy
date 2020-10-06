import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

Widget userSubject(subject) {
  switch (subject) {
    case 'Math':
      return Icon(
        FontAwesomeIcons.plus,
        color: Colors.white,
      );
      break;
    case 'Science':
      return Icon(
        FontAwesomeIcons.flask,
        color: Colors.white,
      );
      break;
    case 'English':
      return Icon(
        FontAwesomeIcons.book,
        color: Colors.white,
      );
      break;
    case 'History':
      return Icon(
        FontAwesomeIcons.globe,
        color: Colors.white,
      );
      break;
    default:
      return null;
      break;
  }
}