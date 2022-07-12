import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

import '../../backend/models/currency_model.dart';
import '../network_constants.dart';

class CurrencyListApi {
  Future<List<CurrencyModel>?> getList() async {
    List<CurrencyModel> list = [];
    try {
      http.Response response = await http.post(
          Uri.parse(baseUrl + currencyListEndpoint),
          body: json.encode({"active": true, "type": "not-fix"}),
          headers: {'Content-Type': 'application/json'});

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body)['data']['currencies'];
        data.removeWhere((element) => element == null);

        list = data.map((item) => CurrencyModel.fromJson(item)).toList();
        return list;
      } else {
        log("/////////////////////////////");
        log("${response.statusCode}");
        var error = json.decode(response.body);
        log('Error :$error');
        return null;
      }
    } catch (e) {
      log('$e');
      return null;
    }
  }
}
