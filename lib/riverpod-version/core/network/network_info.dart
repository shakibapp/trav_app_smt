import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

/// ============================================================================
/// [NetworkInfo] - INTERNET CONNECTIVITY CONTRACT
/// ============================================================================
/// Dependency Inversion Principle (DIP):
/// সরাসরি InternetConnectionChecker এর উপর নির্ভর না করে আমরা একটি অ্যাবস্ট্রাক্ট
/// ইন্টারফেস তৈরি করেছি। 
/// সুবিধা: টেস্টিং এর সময় সহজেই মক (Mock) করা যায়।
/// ============================================================================

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  final InternetConnectionChecker connectionChecker;

  NetworkInfoImpl(this.connectionChecker);

  @override
  Future<bool> get isConnected => connectionChecker.hasConnection;
}

/// Riverpod Provider for NetworkInfo
final networkInfoProvider = Provider<NetworkInfo>((ref) {
  return NetworkInfoImpl(InternetConnectionChecker.createInstance());
});

