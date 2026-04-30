
import 'package:flutter/material.dart';
import 'package:hamishphipps/app/core/constants/app_colors.dart';

appButton({
  required VoidCallback onTap,
  required String name,
  Color bgColor =AppColors.authOrange,
  Color borderColor =AppColors.authOrange,
  Color textColor =AppColors.authOrange,
  double height = 50,
  double width = 200,
  double radius = 20,
}){
  return  GestureDetector(
                onTap:onTap,
                child: Container(
                  height: height,
                  width: width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(radius),
                    color: bgColor,
                    border: Border.all(color: borderColor),
                  ),
                  child: Center(child: Text(name,style:TextStyle(fontSize: 15,color: textColor))),
                ),
              );
}