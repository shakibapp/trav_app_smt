
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
  bool loading = false,
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
                  child: Center(child: loading?SizedBox(height:25,width: 25,child:  CircularProgressIndicator(strokeWidth: 2,)):Text(name,style:TextStyle(fontSize: 15,color: textColor))),
                ),
              );
}