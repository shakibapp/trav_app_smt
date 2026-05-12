import 'package:get/get.dart';
import 'package:hamishphipps/app/core/constants/app_icons.dart';

class InterestController extends GetxController {
  // List of interests
  var interests = <Interest>[
    Interest(title: 'Food & Drink', iconPath: AppIcons.serving),
    Interest(title: 'Nature', iconPath: AppIcons.natural),
    Interest(title: 'Nightlife', iconPath: AppIcons.drink),
    Interest(title: 'Adventure', iconPath:AppIcons.adventure),
    Interest(title: 'Shopping', iconPath: AppIcons.shopping),
    Interest(title: 'Relaxation', iconPath: AppIcons.relieved),
    Interest(title: 'Photography', iconPath: AppIcons.cameraIcon),
    Interest(title: 'History & Culture', iconPath: AppIcons.colosseum),
    Interest(title: 'Art & Music', iconPath:AppIcons.paint),
  ].obs;

  // Selected count check korar jonno getter
  int get selectedCount => interests.where((item) => item.isSelected).length;

  // Toggle function
  void toggleSelection(int index) {
    interests[index].isSelected = !interests[index].isSelected;
     interests.refresh(); // UI update korar jonno
  }
}
class Interest {
  final String title;
  final String iconPath; // Use IconData or Asset path
  bool isSelected;

  Interest({required this.title, required this.iconPath, this.isSelected = false});
}