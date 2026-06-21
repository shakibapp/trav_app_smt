import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ItineraryShimmer extends StatelessWidget {
  const ItineraryShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        children: [
          /// Top Image Shimmer
          shimmerBox(
            height: MediaQuery.of(context).size.height * 0.35,
            width: double.infinity,
            radius: 0,
          ),

          Transform.translate(
            offset: const Offset(0, -20),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Title
                  shimmerBox(
                    height: 24,
                    width: 180,
                  ),

                  const SizedBox(height: 16),

                  /// First Row Chips
                  Row(
                    children: [
                      shimmerBox(
                        height: 35,
                        width: 100,
                        radius: 20,
                      ),
                      const SizedBox(width: 10),
                      shimmerBox(
                        height: 35,
                        width: 140,
                        radius: 20,
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  /// Second Row Chips
                  Row(
                    children: [
                      shimmerBox(
                        height: 35,
                        width: 90,
                        radius: 20,
                      ),
                      const SizedBox(width: 10),
                      shimmerBox(
                        height: 35,
                        width: 130,
                        radius: 20,
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  /// Tabs
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(
                      4,
                          (index) => shimmerBox(
                        height: 40,
                        width: 75,
                        radius: 20,
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  /// Content Cards
                  Column(
                    children: List.generate(
                      4,
                          (index) => Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: shimmerBox(
                          height: 100,
                          width: double.infinity,
                          radius: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget shimmerBox({
    required double height,
    required double width,
    double radius = 12,
  }) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}