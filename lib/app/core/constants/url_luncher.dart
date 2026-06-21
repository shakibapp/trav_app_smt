import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';

Future<void> launchBookingUrl(String url) async {
  final Uri uri = Uri.parse(url);

  try {
    final bool launched = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );
    if (!launched) {
      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
      } else {
        debugPrint("Could not launch $url");
      }
    }
  } catch (e) {
    debugPrint("Exception launching $url: $e");
  }
}