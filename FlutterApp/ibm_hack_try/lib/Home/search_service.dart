import 'package:http/http.dart' as http;

import '../global.dart';

class SearchService {
  static Future<String> searchDjangoApi(String query) async {
    String url = Common.baseURL + 'check_avail?search=$query';
    http.Response response = await http.get(Uri.encodeFull(url));

    print("search_service.dart: searchDjangoApi: ${response.body}");
    if(response.body.runtimeType == [].runtimeType){print("List");}
    else{print ("String");}
    return response.body;
  }
}