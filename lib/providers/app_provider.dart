import 'package:flutter/foundation.dart';
import 'package:pgfy/providers/db_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

class AppProvider with ChangeNotifier {
  DbProvider dbProvider = DbProvider();

  List<String> _urls = [];

  List<String> get urls => _urls;

  addUrl(String url) async{
    await dbProvider.addUrl(url);
    _urls.clear();
    _urls = await dbProvider.fetchUrls();
    notifyListeners();
  }

  Future<bool> getUrls() async {
    _urls = await dbProvider.fetchUrls();
    return true;
  }

  Future<int> ping(String url) async {
    http.Response response = await http.get(Uri.parse(url));

    if (response.statusCode < 200 || response.statusCode > 299) {
      await ping(url);
      return response.statusCode;
    }
    /*Future.delayed(const Duration(seconds: 10), () {
      ping(url);
    });*/
    return 0;
  }
}
