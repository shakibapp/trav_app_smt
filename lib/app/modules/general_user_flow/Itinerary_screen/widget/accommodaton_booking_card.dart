

import 'package:flutter/material.dart';
import 'package:hamishphipps/app/modules/general_user_flow/Itinerary_screen/model/tripltinerary_overview_model.dart';
import 'package:intl/intl.dart';
import 'package:hamishphipps/app/core/constants/app_colors.dart';


class AccommodationCard extends StatelessWidget {
  final Accommodation accommodation;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;

  const AccommodationCard({
    super.key,
    required this.accommodation,
    this.onTap,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final checkIn = accommodation.checkInDate;
    final checkOut = accommodation.checkOutDate;
    final totalCost = accommodation.totalCost ?? 0;
    final amountOwing = accommodation.amountOwing ?? 0;
    final currency = accommodation.currency ?? 'EUR';
    final nights = accommodation.totalNights ?? 0;
    final guests = accommodation.numberOfGuests ?? 1;
    final paymentStatus = accommodation.paymentStatus ?? '';
    final type = accommodation.type ?? '';

    final stillOwes = amountOwing > 0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Row 1: Icon + Name + Type badge + Edit icon
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hotel icon box
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.authOrange,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Icon(
                      _getAccommodationIcon(type),
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                ),
                const SizedBox(width: 10),

                // Name + address
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              accommodation.name ?? 'Unknown',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 6),
                          // Type badge
                          if (type.isNotEmpty)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: Colors.green.shade50,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                    color: Colors.green.shade200, width: 1),
                              ),
                              child: Text(
                                _capitalise(type),
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.green.shade700,
                                ),
                              ),
                            ),
                        ],
                      ),
                      if (accommodation.address != null &&
                          accommodation.address!.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          accommodation.address!,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.grey,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),

                // Edit icon
                GestureDetector(
                  onTap: onEdit,
                  child: const Padding(
                    padding: EdgeInsets.only(left: 6),
                    child: Icon(Icons.edit_outlined,
                        size: 18, color: Colors.black54),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),
            const Divider(height: 1, color: Color(0xFFf0f0f0)),
            const SizedBox(height: 14),

            // ── Row 2: Check-in / Check-out
            Row(
              children: [
                Expanded(
                  child: _buildDateColumn(
                    label: 'Check-in',
                    date: checkIn,
                  ),
                ),
                Expanded(
                  child: _buildDateColumn(
                    label: 'Check-out',
                    date: checkOut,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            // ── Row 3: Nights + Guests chips
            Row(
              children: [
                _buildChip(
                  icon: Icons.nights_stay_outlined,
                  label: '$nights ${nights == 1 ? 'night' : 'nights'}',
                ),
                const SizedBox(width: 10),
                _buildChip(
                  icon: Icons.people_outline,
                  label: '$guests ${guests == 1 ? 'Guest' : 'Guests'}',
                ),
              ],
            ),

            const SizedBox(height: 14),
            const Divider(height: 1, color: Color(0xFFf0f0f0)),
            const SizedBox(height: 14),

            // ── Row 4: Total cost + Still Owe badge
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '$currency ${totalCost.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(width: 10),
                if (stillOwes)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.authOrange,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Still Owe $currency ${amountOwing.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  )
                else if (paymentStatus.toLowerCase() == 'paid')
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green.shade500,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Paid ✓',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ── Date column helper
  Widget _buildDateColumn({required String label, required DateTime? date}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: Colors.grey,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          date != null
              ? DateFormat('yyyy-MM-dd').format(date)
              : 'Not set',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  // ── Chip helper (nights / guests)
  Widget _buildChip({required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFf5f5f5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.black54),
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  // ── Icon per accommodation type
  IconData _getAccommodationIcon(String type) {
    switch (type.toLowerCase()) {
      case 'hotel':
        return Icons.hotel_outlined;
      case 'hostel':
        return Icons.bed_outlined;
      case 'apartment':
      case 'airbnb':
        return Icons.apartment_outlined;
      case 'villa':
        return Icons.house_outlined;
      case 'resort':
        return Icons.beach_access_outlined;
      default:
        return Icons.business_outlined;
    }
  }

  String _capitalise(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1).toLowerCase();
}