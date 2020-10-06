import 'package:flutter/material.dart';

Widget subjectWidget(icon, text, size, selected, onTap){ 
  return GestureDetector(
    onTap: onTap,
    child: Column( 
      children: <Widget>[
        Icon( 
          icon,
          size: size.height *0.07,
          color: selected == text ? Colors.indigoAccent[200]: Colors.indigoAccent[100],
        ),
        SizedBox(
          height: size.height *0.03,
        ),
        Text( 
          text,
          style: TextStyle( 
            color: selected == text ? Colors.indigoAccent[200]: Colors.indigoAccent[100],
          ),
        )
      ],
    ),
  );
}