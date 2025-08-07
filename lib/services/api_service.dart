import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:video_ott_app/services/api_route.dart';

class ApiService {
  bool realRequest = true;

  get website => ApiRoute.BASE_URL;

  BuildContext? context;

  ApiService({this.context});

  var headers = {
    "Accept": "application/json",
    "Content-Type": "application/json",
  };

  post({required String url, Object? body}) async {
    final response = await http.post(Uri.parse(website + url), body: body);
    if (response.statusCode == 200) {
      return response.body;
    }
    var res = jsonDecode(response.body);
    return res;
  }

  get({required String url, Map? params}) async {
    // print(params);
    if (params != null) {
      var queryParams = "?";
      params.forEach((key, value) {
        queryParams = queryParams + "$key=$value" + "&";
      });
      queryParams = queryParams.substring(0, queryParams.length - 1);
      url = url + queryParams;
    }
    // print(url);
    final response = await http.get(Uri.parse(website + url), headers: headers);

    if (response.statusCode == 200) {
      return response.body;
    }

    var res = response.body;

    return res;
  }

  bool _isNetworkAvail = true;

  Future<void> checkNetwork() async {

  }

  request(
      {required String url,
        required method ,
        Map<String, dynamic>? params,
        Map<String, dynamic>? body}) async {
    if (true) {
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

        // dio.interceptors.add(Logging(context: context));

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
          // print('STATUS: ${e.response?.statusCode}');
          print('DATA: ${e.response?.data}');
          // print('HEADERS: ${e.response?.headers}');

          return e.response?.data.toString();
        } else {
          print("=====show from ApiService 1 =====");
          print(e.message);
          return e.message.toString();
        }
      }
    } else {
      // toast("no internet connection . check your network");
    }
  }
}