import 'dart:developer';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../backend/models/init_table_model.dart';
import '../../backend/models/currency_model.dart';
import '../network_constants.dart';

class InitTableApi {
  Future<Map<String, dynamic>?> initTable() async {
    http.Response response =
        await http.get(Uri.parse(baseUrl + initTabelEndpoint));

    if (response.statusCode == 200) {
      Map<String, dynamic> estimateData =
          json.decode(response.body)['data']['estimate'];
      InitTabelModel decodedestimateData =
          InitTabelModel.fromJson(estimateData);
      List<dynamic> listData =
          json.decode(response.body)['data']["list"]['currencies'];
      listData.removeWhere((element) => element == null);
      List<CurrencyModel> decodedListData =
          listData.map((item) => CurrencyModel.fromJson(item)).toList();
      Map<String, dynamic> result = {
        'estimate': decodedestimateData,
        'list': decodedListData
      };

      return result;
    } else {
      log("/////////////////////////////");
      log("${response.statusCode}");
      var error = json.decode(response.body);
      log('Error :$error');
      return null;
    }
  }

  Future<InitTabelModel?> estimate() async {
    http.Response response =
        await http.get(Uri.parse(baseUrl + initTabelEndpoint));

    if (response.statusCode == 200) {
      Map<String, dynamic> data =
          json.decode(response.body)['data']['estimateBTCETH'];

      InitTabelModel decodedData = InitTabelModel.fromJson(data);
      log('$decodedData');
      return decodedData;
    } else {
      log("${response.statusCode}");
    }
    return null;
  }

  Future<List<CurrencyModel>?> getList() async {
    List<CurrencyModel> list = [];
    try {
      http.Response response =
          await http.get(Uri.parse(baseUrl + initTabelEndpoint));

      if (response.statusCode == 200) {
        List<dynamic> data =
            json.decode(response.body)['data']["list"]['currencies'];
        data.removeWhere((element) => element == null);

        list = data.map((item) => CurrencyModel.fromJson(item)).toList();
        log("$list");

        return list;
      } else {
        log("${response.statusCode}");
      }
    } catch (e) {
      log('$e');
    }
    return null;
  }
}
