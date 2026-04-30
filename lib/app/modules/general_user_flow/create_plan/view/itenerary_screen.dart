import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hamishphipps/app/core/constants/app_button.dart';
import 'package:hamishphipps/app/core/constants/app_colors.dart';
import 'package:hamishphipps/app/core/constants/app_icons.dart';
import 'package:hamishphipps/app/modules/general_user_flow/create_plan/widget/back_button_widget.dart';

import '../controller/itinerary_controller.dart';

class ItineraryView extends StatelessWidget {
  final ItineraryController controller = Get.put(ItineraryController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(10.0),
          child: backButton(),
        ),
        title: Text(
          "Your Itinerary",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeroImage(),
            SizedBox(height: 20),
            _buildRemindersSection(),
            SizedBox(height: 15),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFFffe7d9),
                    Color(0xFFfefef8),
                    Color(0xFFf3f5c4),
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(5),
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Image.asset(
                      AppIcons.alertCircle,
                      height: 30,
                      width: 30,
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    "Priority Reminders (Need Attention)",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15),
            _buildOptimizationCard(),
            SizedBox(height: 20),
            Text(
              "Itinerary",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            _buildTimelineList(),
          ],
        ),
      ),
    );
  }

  // Header Image with Badges
  Widget _buildHeroImage() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
          image: AssetImage('assets/images/italy.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            bottom: 20,
            left: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Italy",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    _smallBadge(Icons.calendar_today, "Mar 18 - Mar 28, 2026"),
                    SizedBox(width: 5),
                    _smallBadge(Icons.flag, "5 Days"),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Horizontal Reminder Cards
  Widget _buildRemindersSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Reminders",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        SizedBox(
          height: 150,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,

            itemBuilder: (context, index) {
              return Container(
                width: 300,
                margin: EdgeInsets.only(right: 10),
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: AppColors.orangeLight,
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(color: AppColors.authOrange),
                          ),
                          child: Image.asset(
                            AppIcons.airplaneColor,
                            height: 20,
                            width: 20,
                          ),
                        ),
                        SizedBox(width: 10),
                        appButton(
                          height: 30,
                          width: 100,

                          onTap: () {},
                          name: '5 Days Left',
                          textColor: Colors.white,
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Book flight to Rome",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Arriving 20 Mar, 2026",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: appButton(
                            height: 30,
                            onTap: () {},
                            name: "Dismiss",
                            bgColor: Color(0xFFf7ebe4),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: appButton(
                            height: 30,
                            onTap: () {},
                            name: "Done",
                            bgColor: AppColors.authOrange,
                            textColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // Optimization Suggestion Card
  Widget _buildOptimizationCard() {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFffe7d9), Color(0xFFfefef8), Color(0xFFf3f5c4)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        // color: Colors.lightGreen.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.green.shade100),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(4),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: Color(0xFFFFBB91),
                  border: Border.all(color: AppColors.authOrange),
                ),
                child: Image.asset(AppIcons.routeIcon, height: 20, width: 20),
              ),

              SizedBox(width: 10),
              Text(
                "Optimise your route",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(100),
                ),

                child: Text(
                  "Save 3h",
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.green,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Text(
            "Consider visiting Berlin before Amsterdam to reduce travel time.",
            style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
          ),
          SizedBox(height: 15),
          ElevatedButton(
            onPressed: () => controller.applyOptimization(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.authOrange,
              minimumSize: Size(double.infinity, 45),
              shape: StadiumBorder(),
            ),
            child: Text("Apply", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // Timeline List
  Widget _buildTimelineList() {
    return Obx(
      () => ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: controller.itineraryList.length,
        itemBuilder: (context, index) {
          final item = controller.itineraryList[index];
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  CircleAvatar(
                    radius: 12,
                    backgroundColor: Colors.black87,
                    child: Text(
                      "${index + 1}",
                      style: TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ),
                  Container(width: 2, height: 100, color: Colors.grey.shade300),
                ],
              ),
              SizedBox(width: 15),
              Expanded(
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.cityName,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                item.duration,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Icon(
                                    Icons.check_circle,
                                    size: 16,
                                    color: AppColors.authOrange,
                                  ),
                                  SizedBox(width: 5),
                                  Icon(
                                    Icons.error,
                                    size: 16,
                                    color: AppColors.authOrange,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.horizontal(
                          right: Radius.circular(15),
                        ),
                        child: Image.asset(
                          item.imageUrl,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // Helper Widgets
  Widget _smallBadge(IconData icon, String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 12),
          SizedBox(width: 4),
          Text(text, style: TextStyle(color: Colors.white, fontSize: 10)),
        ],
      ),
    );
  }

  Widget _reminderCard(String title, String subtitle) {
    return Container(
      width: 250,
      margin: EdgeInsets.only(right: 10),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
          Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey)),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: appButton(
                  height: 30,
                  onTap: () {},
                  name: "Dismiss",
                  bgColor: Color(0xFFf7ebe4),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: appButton(
                  height: 30,
                  onTap: () {},
                  name: "Done",
                  bgColor: AppColors.authOrange,
                  textColor: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
