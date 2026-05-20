import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hamishphipps/app/core/constants/app_button.dart';
import 'package:hamishphipps/app/core/constants/app_colors.dart';
import 'package:hamishphipps/app/core/constants/app_icons.dart';
import 'package:hamishphipps/app/core/constants/url_luncher.dart';
import 'package:hamishphipps/app/modules/general_user_flow/Itinerary_screen/controller/tripltinerary_overview_controller.dart';
import 'package:hamishphipps/app/modules/general_user_flow/Itinerary_screen/model/tripltinerary_overview_model.dart';
import 'package:hamishphipps/app/modules/general_user_flow/add_accommodation_screen/booking_with_card.dart';
import 'package:hamishphipps/app/modules/general_user_flow/add_transportation_screen/view/add_transportation_screen.dart';

class TravelTabScreen extends StatelessWidget {
  final ItineraryDetailsController controller;
  const TravelTabScreen({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Plan Your Transport',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text(
          'Find the best way to travel between your destinations — flights, trains, or buses.',
          style: TextStyle(color: Colors.grey, fontSize: 14),
        ),
        const SizedBox(height: 16),
        appButton(
          width: double.infinity,
          height: 45,
          bgColor: Colors.transparent,
          textColor: AppColors.blackColor,
          borderColor: Colors.grey.shade300,
          onTap: () => Get.to(() => AddTransportationView(
                id: controller.itineraryOverview.value.id?.toString() ?? "",
              )),
          name: "Add Booking Details",
        ),
        const SizedBox(height: 24),
        ListView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount:
              controller.itineraryOverview.value.transportations?.length ?? 0,
          itemBuilder: (context, index) {
            final transport =
                controller.itineraryOverview.value.transportations![index];
            return _buildTransportCard(transport);
          },
        ),
         Text(
          'Book With',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
       buildBookingPlatform(controller.itineraryOverview.value.transportation),
      ],
    );
  }

  Widget _buildTransportCard(Transportation transport) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(_getTransportIcon(transport.type),
                      size: 20, color: Colors.grey.shade600),
                  const SizedBox(width: 8),
                  Text(
                    transport.type ?? "Unknown",
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              Icon(Icons.edit_outlined, size: 18, color: Colors.grey.shade500),
            ],
          ),
          const SizedBox(height: 14),

          // Route row
          Row(
            children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(_airportCode(transport.dpeartureLocation),
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w600)),
                Text(transport.dpeartureLocation ?? "",
                    style:
                        TextStyle(fontSize: 12, color: Colors.grey.shade500)),
              ]),
              Expanded(
                child: Column(children: [
                  Icon(_getTransportIcon(transport.type),
                      size: 18, color: Colors.grey.shade400),
                  Divider(color: Colors.grey.shade300, thickness: 0.5),
                ]),
              ),
              Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Text(_airportCode(transport.arrivalLocation),
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w600)),
                Text(transport.arrivalLocation ?? "",
                    style:
                        TextStyle(fontSize: 12, color: Colors.grey.shade500)),
              ]),
            ],
          ),
          const SizedBox(height: 12),

          // Dates
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _dateBlock("Departure", transport.departureDate,
                  transport.departureTime, false),
              _dateBlock(
                  "Arrive", transport.arrivalDate, transport.arrivalTime, true),
            ],
          ),
          const SizedBox(height: 12),

          // Type-specific details
          ..._buildTypeDetails(transport),
          const SizedBox(height: 12),

          const Divider(thickness: 0.5),
          Text(
            "${transport.currency ?? "EUR"} ${((transport.totalCost ?? 0))}",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  IconData _getTransportIcon(String? type) {
    switch (type?.toLowerCase()) {
      case 'flight':
        return Icons.flight_takeoff;
      case 'bus':
        return Icons.directions_bus;
      case 'car':
        return Icons.directions_car;
      case 'train':
        return Icons.train;
      case 'ferry':
        return Icons.directions_boat;
      default:
        return Icons.directions_car;
    }
  }

  Widget _dateBlock(
      String label, DateTime? date, String? time, bool rightAlign) {
    final dateStr = date != null
        ? "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}"
        : "DD/MM/YYYY";
    return Column(
      crossAxisAlignment:
          rightAlign ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
        Text(dateStr, style: const TextStyle(fontSize: 13)),
        Text(time ?? "",
            style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
      ],
    );
  }

  List<Widget> _buildTypeDetails(Transportation transport) {
    Map<String, String?> details = {};

    switch (transport.type?.toLowerCase()) {
      case 'flight':
        details = {
          'Airline': transport.airline,
          'Booking Reference': transport.bookingReference,
          'Flight Number': transport.flightNumber,
          'Terminal': transport.terminal,
          'Gate': transport.gate,
          'Seat': transport.seat?.toString(),
        };
        break;
      case 'bus':
        details = {
          'Bus Company': transport.busCompany?.toString(),
          'Booking Reference': transport.bookingReference,
          'Service Number': transport.serviceNumber?.toString(),
          'Seat': transport.seat?.toString(),
        };
        break;
      case 'car':
        details = {
          'Booking Reference': transport.bookingReference,
          'Car Number': transport.carNumberPlate?.toString(),
          'Seat': transport.seat?.toString(),
        };
        break;
      case 'train':
      case 'ferry':
        details = {
          'Train Operator': transport.trainOperator?.toString(),
          'Booking Reference': transport.bookingReference,
          'Train Number': transport.trainNumber?.toString(),
          'Seat': transport.seat?.toString(),
        };
        break;
    }

    return details.entries
        .where((e) => e.value != null && e.value!.isNotEmpty)
        .map((e) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(e.key,
                      style:
                          TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                  Text(e.value!,
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w500)),
                ],
              ),
            ))
        .toList();
  }

  String _airportCode(String? location) {
    if (location == null || location.isEmpty) return "---";
    return location.length >= 3
        ? location.substring(0, 3).toUpperCase()
        : location.toUpperCase();
  }


  IconData getAccommodationIcon(String? type) {
    switch (type) {
      case "Hotel":
        return Icons.hotel;

      case "Hostel":
        return Icons.bed;

      case "Airbnb":
        return Icons.airplane_ticket_outlined;

      case "Guesthouse":
        return Icons.house;

      case "Resort":
        return Icons.beach_access;

      case "Camping":
        return Icons.forest;

      case "Other":
        return Icons.apartment;

      case "Not_Sure_Yet":
        return Icons.help_outline;

      default:
        return Icons.location_city;
    }
  }

 Widget buildBookingPlatform(String? type) {
  switch (type) {
    case "Train":
    case "Bus":
    case "Car Rental":
      return  BookingCard(
          title: "Rome2Rio",
          subtitle: "Discover how to get anywhere",
          logoPath: AppIcons.romo,
          onTap: () {
            launchBookingUrl("https://www.rome2rio.com/");
          },
        );

    case "Flight":
      return BookingCard(
          title: "Skyscanner",
          subtitle: "Millions of cheap flights. One simple search.",
          logoPath: AppIcons.sky,
          onTap: () {
            launchBookingUrl("https://www.hostelworld.com/");
          },
        );

    
    case "Not_Sure_Yet":
      return Column(
        children: [
          BookingCard(
          title: "Skyscanner",
          subtitle: "Millions of cheap flights. One simple search.",
          logoPath: AppIcons.sky,
          onTap: () {
            launchBookingUrl("https://www.hostelworld.com/");
          },
        ),
        BookingCard(
          title: "Roome2Rio",
          subtitle: "Discover how to get anywhere",
          logoPath: AppIcons.romo,
          onTap: () {
            launchBookingUrl("https://www.rome2rio.com/");
          },
        ),
        
        ],
      );

    default:
      return BookingCard(
        title: "Booking.com",
        subtitle: "Great for hotels, resorts, and flexible options",
        logoPath: AppIcons.booking,
        onTap: () => launchBookingUrl("https://www.booking.com/"),
      );
  }
}
}
