import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../global.dart';

class MaterialFetch {
  static Future<List<dynamic>> searchDjangoApi(String query) async {
    String url = Common.baseURL + 'check_avail?search=$query';
    //http.Response response = await http.get(Uri.encodeFull(url));
    final response = await http.get(Uri.encodeFull(url));
    //print("searchDjangoApi: ${response.body}");
    List<dynamic> data= jsonDecode(response.body);
    // print(data);
    return (data);
  }
}
