import 'package:flutter/material.dart';
import 'package:hamishphipps/app/core/constants/app_colors.dart';

Widget priorityRemainder({
  required BuildContext context,
  required String title,
  required VoidCallback onUpdate,
  required String buttonText,
  required IconData icon,
}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
    decoration: BoxDecoration(
      color: Colors.grey[100],
      borderRadius: BorderRadius.circular(10),
    ),
    child: Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.orange[50],
            shape: BoxShape.circle,
          ),
          child:  Icon(
            Icons.badge_outlined,
            color: AppColors.authOrange,
            size: 24,
          ),
        ),
        const SizedBox(width: 5),

        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ),

        ElevatedButton(
          onPressed: onUpdate,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.authOrange,
            foregroundColor: Colors.white,
            shape: const StadiumBorder(),
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          ),
          child:  Text(
            buttonText,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    ),
  );
}
