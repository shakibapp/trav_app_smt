import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';

Future<void> launchBookingUrl(String url) async {
  final Uri uri = Uri.parse(url);

  if (await canLaunchUrl(uri)) {
    await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );
  } else {
    debugPrint("Could not launch $url");
  }
}