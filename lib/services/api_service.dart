import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:video_ott_app/services/api_route.dart';
import 'package:video_ott_app/views/home_screen.dart';

class ApiService {

  get website => ApiRoute.BASE_URL;

  BuildContext? context;

  ApiService({this.context});

  // Generic request method that supports GET, POST, etc.
  // url: endpoint path (query parameters appended automatically if provided)
  // method: HTTP method as String, e.g. "GET", "POST"
  // context: optional BuildContext for showing error dialogs
  // params: optional query parameters for GET requests
  // body: optional request body for POST/PUT requests
  request(
      {required String url,
        required method ,
        BuildContext? context,
        Map<String, dynamic>? params,
        Map<String, dynamic>? body}) async {

      try {
        var options = BaseOptions(
          baseUrl: website,
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/json",
          },
        ); // Setup Dio options including base URL and headers

        method ??= "GET"; // Default to GET if no method specified

        Dio dio = Dio(options);

        Response response = await dio.request(
          url,
          queryParameters: params,
          data: body,
          options: Options(method: method),
        ); // Make HTTP request using Dio

        return response.toString();

      } on DioError catch (e) {
        // Handle errors when response is available (e.g. 4xx, 5xx HTTP errors)
        if (e.response != null) {
          print("===== ApiService: HTTP Error Response =====");
          print('STATUS: ${e.response?.statusCode}');
          print('DATA: ${e.response?.data}');
          print('HEADERS: ${e.response?.headers}');

          return e.response?.data.toString();
        } else {
          // Handle errors without response (e.g. no internet, timeout)
          print("===== ApiService: Network Error =====");
          print(e.message);
          if (context != null) {
            _showNoInternetDialog(context);
          }

          return e.message.toString();
        }
      }
  }

  // method to display a no internet connection dialog and navigate to HomeScreen
  void _showNoInternetDialog(context) {
      showDialog(
        context: context!,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Connection Error'),
            content: Text('No Internet Connection!'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop(); // Close dialog
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomeScreen(),
                    ),
                  );
                },
              ),
            ],
          );
        },
      );
  }

}