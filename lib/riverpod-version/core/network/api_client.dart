import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../errors/exceptions.dart';

/// ============================================================================
/// [ApiClient] - REUSABLE HTTP CLIENT
/// ============================================================================
/// এই ক্লাসটি সেন্ট্রালাইজড ভাবে সব ধরনের নেটওয়ার্ক কল (GET, POST, PUT, DELETE)
/// এক্সিকিউট করে।
/// 
/// কেন এই প্যাটার্ন সিনিয়র লেভেলের?
/// ১. প্রতিটি ফিচারে গিয়ে http.post(...) লেখার কোনো প্রয়োজন নেই।
/// ২. সব রিকোয়েস্টের হেডার, টাইমআউট এবং JSON এনকোডিং এক জায়গা থেকে কন্ট্রোল হয়।
/// ৩. রেসপন্স কোড অনুযায়ী অটোমেটিকালি উপযুক্ত Exception (ServerException, AuthException)
///    থ্রো করে যা ডেটা লেয়ার সহজে ক্যাচ করতে পারে।
/// ============================================================================

abstract class ApiClient {
  Future<dynamic> get(String url, {Map<String, String>? headers});
  Future<dynamic> post(String url, {Map<String, dynamic>? body, Map<String, String>? headers});
  Future<dynamic> put(String url, {Map<String, dynamic>? body, Map<String, String>? headers});
  Future<dynamic> delete(String url, {Map<String, String>? headers});
}

class ApiClientImpl implements ApiClient {
  final http.Client client;
  static const Duration timeoutDuration = Duration(seconds: 30);

  ApiClientImpl({http.Client? client}) : client = client ?? http.Client();

  Map<String, String> _defaultHeaders(Map<String, String>? headers) {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      ...?headers,
    };
  }

  @override
  Future<dynamic> get(String url, {Map<String, String>? headers}) async {
    try {
      final response = await client
          .get(Uri.parse(url), headers: _defaultHeaders(headers))
          .timeout(timeoutDuration);
      return _processResponse(response);
    } on SocketException {
      throw const NetworkException();
    } on TimeoutException {
      throw const ServerException(message: 'Request timed out. Please try again.');
    }
  }

  @override
  Future<dynamic> post(
    String url, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    try {
      final response = await client
          .post(
            Uri.parse(url),
            headers: _defaultHeaders(headers),
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(timeoutDuration);
      return _processResponse(response);
    } on SocketException {
      throw const NetworkException();
    } on TimeoutException {
      throw const ServerException(message: 'Request timed out. Please try again.');
    }
  }

  @override
  Future<dynamic> put(
    String url, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    try {
      final response = await client
          .put(
            Uri.parse(url),
            headers: _defaultHeaders(headers),
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(timeoutDuration);
      return _processResponse(response);
    } on SocketException {
      throw const NetworkException();
    } on TimeoutException {
      throw const ServerException(message: 'Request timed out. Please try again.');
    }
  }

  @override
  Future<dynamic> delete(String url, {Map<String, String>? headers}) async {
    try {
      final response = await client
          .delete(Uri.parse(url), headers: _defaultHeaders(headers))
          .timeout(timeoutDuration);
      return _processResponse(response);
    } on SocketException {
      throw const NetworkException();
    } on TimeoutException {
      throw const ServerException(message: 'Request timed out. Please try again.');
    }
  }

  /// রেসপন্স প্রসেসিং ও সেন্ট্রাল এক্সেপশন হ্যান্ডলিং
  dynamic _processResponse(http.Response response) {
    dynamic jsonResponse;
    try {
      jsonResponse = jsonDecode(response.body);
    } catch (_) {
      jsonResponse = null;
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (jsonResponse is Map<String, dynamic> && jsonResponse['success'] == false) {
        throw ServerException(
          message: jsonResponse['message'] ?? 'Action failed',
          statusCode: response.statusCode,
        );
      }
      return jsonResponse;
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      final message = jsonResponse is Map<String, dynamic>
          ? (jsonResponse['message'] ?? 'Unauthorized access.')
          : 'Unauthorized access.';
      throw AuthException(message: message);
    } else {
      final message = jsonResponse is Map<String, dynamic>
          ? (jsonResponse['message'] ?? 'Server error occurred (${response.statusCode})')
          : 'Server error occurred (${response.statusCode})';
      throw ServerException(
        message: message,
        statusCode: response.statusCode,
      );
    }
  }
}

/// Riverpod Provider for ApiClient
final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClientImpl();
});

