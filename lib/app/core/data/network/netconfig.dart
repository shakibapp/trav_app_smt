import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:hamishphipps/app/core/constants/app_snackbar.dart';
import 'package:hamishphipps/app/core/services/logger.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart'; // added
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mime/mime.dart'; // added
import 'package:path/path.dart' as p;

import '../../services/local_data.dart';
import '../../widgets/app_snackbar.dart';

enum RequestMethod {
  GET,
  POST,
  PUT,
  PATCH,
  PUT_V2,
  MULTIPART,
  MULTIPART_PUT,
  DELETE,
}

class NetworkConfigV1 {
  final localService = LocalService.localService;

  NetworkConfigV1._privateConstructor();

  static final NetworkConfigV1 _instance =
      NetworkConfigV1._privateConstructor();

  static NetworkConfigV1 get instance => _instance;

  Future<dynamic> ApiRequestHandler(
    RequestMethod method,
    String url,
    dynamic json_body, {
    bool is_auth = false,
    dynamic imagePath = const [],
    String dataPathName = "data",
    String filePathName = "image",
    String? authToken,
  }) async {
    final checker = InternetConnectionChecker.createInstance();
    if (await checker.hasConnection) {
      final header = <String, String>{
        "Content-Type": "application/json",
        "Accept": "application/json",
      };

      if (is_auth) {
        final token = (authToken != null && authToken.isNotEmpty)
            ? authToken
            : await localService.getToken();
        if (token != null && token.isNotEmpty) {
          header["Authorization"] = token.trim();
        }
      }

      logger.d("Request Headers: $header");

      try {
        switch (method) {
          case RequestMethod.GET:
            {
              final req = await http.get(Uri.parse(url), headers: header);
              _debug(req);
              return _handleJsonResponse(req);
            }

          case RequestMethod.POST:
            {
              final req = await http.post(
                Uri.parse(url),
                headers: header,
                body: json_body is String
                    ? json_body
                    : json.encode(json_body ?? {}),
              );
              _debug(req);
              return _handleJsonResponse(req);
            }

          case RequestMethod.PATCH:
            {
              final req = await http.patch(
                Uri.parse(url),
                headers: header,
                body: json_body is String
                    ? json_body
                    : json.encode(json_body ?? {}),
              );
              _debug(req);
              return _handleJsonResponse(req);
            }

          case RequestMethod.PUT:
            {
              final req = await http.put(
                Uri.parse(url),
                headers: header,
                body: json_body is String
                    ? json_body
                    : json.encode(json_body ?? {}),
              );
              _debug(req);
              return _handleJsonResponse(req);
            }

          case RequestMethod.DELETE:
            {
              final req = await http.delete(Uri.parse(url), headers: header);
              _debug(req);
              return _handleJsonResponse(req);
            }

          case RequestMethod.MULTIPART:
            {
              return _handleMultipartRequest(
                'POST',
                url,
                json_body,
                imagePath,
                dataPathName,
                filePathName,
                authToken: authToken,
              );
            }

          case RequestMethod.MULTIPART_PUT:
            {
              return _handleMultipartRequest(
                'PUT',
                url,
                json_body,
                imagePath,
                dataPathName,
                filePathName,
                authToken: authToken,
              );
            }

          case RequestMethod.PUT_V2:
            {
              // multipart PUT for updating fields only
              final request = http.MultipartRequest("PUT", Uri.parse(url));
              final token = (authToken != null && authToken.isNotEmpty)
                  ? authToken
                  : await localService.getToken();
              if (token != null && token.isNotEmpty) {
                header["Authorization"] = token.trim();
              }
              request.headers.addAll(header);

              if (json_body != null) {
                final asString = json_body is String
                    ? json_body
                    : json.encode(json_body);
                request.fields["data"] = asString;
              }

              final streamedResponse = await request.send();
              final response = await http.Response.fromStream(streamedResponse);
              logger.d("PUT response: ${response.statusCode}");
              logger.d(response.body);
              return _handleJsonResponse(response);
            }
        }
      } catch (e, st) {
        log('Network error: $e\n$st');
        ShowError('Something went wrong. Please try again.');
      }
    } else {
      AppSnackbar.failed("Please Connect Internet");
    }
    return null;
  }

  Future<dynamic> _handleMultipartRequest(
    String method,
    String url,
    dynamic json_body,
    dynamic imagePath,
    String dataPathName,
    String filePathName, {
    String? authToken,
  }) async {
    final token = (authToken != null && authToken.isNotEmpty)
        ? authToken
        : await localService.getToken();

    final request = http.MultipartRequest(method, Uri.parse(url));
    request.headers.addAll({
      'Accept': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': token,
      // or 'Bearer $token'
    });

    // add JSON field
    final String dataFieldName = dataPathName;
    final String dataPayload = json_body is String
        ? (json_body.isNotEmpty ? json_body : '{}')
        : json.encode(json_body ?? {});
    request.fields[dataFieldName] = dataPayload;
    // print convenience
    logger.d('📤 Data field "$dataFieldName": $dataPayload');

    // normalize files
    final List<File> files = imagePath is List<File>
        ? imagePath
        : imagePath is Iterable
        ? List<File>.from(imagePath)
        : <File>[];

    logger.d('📸 Files to upload: ${files.length}');
    for (var i = 0; i < files.length; i++) {
      final f = files[i];
      if (!await f.exists()) {
        logger.d('❌ File not found: ${f.path}');
        continue;
      }
      final filename = p.basename(f.path);
      final mimeType = lookupMimeType(f.path) ?? 'application/octet-stream';
      final contentType = MediaType.parse(mimeType);

      final part = await http.MultipartFile.fromPath(
        filePathName,
        f.path,
        filename: filename,
        contentType: contentType,
      );
      request.files.add(part);
      logger.d(
        '✅ Added file #$i -> field="$filePathName", name="$filename", type="$mimeType"',
      );
    }

    final streamed = await request.send();
    final response = await http.Response.fromStream(streamed);
    logger.d('📥 Response status: ${response.statusCode}');
    logger.d('📥 Response body: ${response.body}');
    return _handleJsonResponse(response);
  }

  dynamic _handleJsonResponse(http.Response resp) {
    final code = resp.statusCode;
    if (code >= 200 && code < 300) {
      try {
        return json.decode(resp.body);
      } catch (_) {
        return resp.body; // not JSON; return as string
      }
    }

    try {
      final data = json.decode(resp.body);
      final msg =
          data['message'] ??
          (code >= 500 ? 'Server Error' : 'Try again after some time');
      ShowError(msg);
      return data;
    } catch (_) {
      ShowError(code >= 500 ? 'Server Error' : 'Try again after some time');
      return null;
    }
  }

  void _debug(http.Response r) {
    logger.d('[${r.request?.method}] ${r.request?.url} -> ${r.statusCode}');
    logger.d(r.body);
  }

  void ShowError(Object msg) {
    AppSnackbar.failed(msg.toString());
    
  }
}
