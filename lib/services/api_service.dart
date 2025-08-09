import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:video_ott_app/services/api_route.dart';
import 'package:video_ott_app/views/home_screen.dart';

class ApiService {
  bool realRequest = true;

  get website => ApiRoute.BASE_URL;

  BuildContext? context;

  ApiService({this.context});

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
        );

        method ??= "GET";

        Dio dio = Dio(options);

        Response response = await dio.request(
          url,
          queryParameters: params,
          data: body,
          options: Options(method: method),
        );

        return response.toString();

      } on DioError catch (e) {
        if (e.response != null) {
          print("=====show from ApiService 2 =====");
          print('STATUS: ${e.response?.statusCode}');
          print('DATA: ${e.response?.data}');
          print('HEADERS: ${e.response?.headers}');

          return e.response?.data.toString();
        } else {
          print("=====show from ApiService 1 =====");
          print(e.message);
          if (context != null) {
            _showNoInternetDialog(context);
          }

          return e.message.toString();
        }
      }
  }

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