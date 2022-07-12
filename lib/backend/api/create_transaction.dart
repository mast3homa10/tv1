import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import '../../backend/models/create_transaction_model.dart';
import '../network_constants.dart';

class CreateTransactionApi {
  Future<CreateTransactionModel?> create() async {
    http.Response response =
        await http.post(Uri.parse(baseUrl + createTransactionEndpoint),
            body: json.encode({
              "sourceCurrency": "btc",
              "sourceNetwork": "btc",
              "destinationCurrency": "usdt",
              "destinationNetwork": "eth",
              "sourceAmount": "0.1",
              "payoutAddress": "0xD1220A0cf47c7B9Be7A2E6BA89F429762e7b9aDb",
              "type": "not-fix",
              "directionOfExchangeFlow": "direct"
            }),
            headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 200) {
      Map<String, dynamic> data =
          json.decode(response.body)['data']['createExchangeResult'];

      var decodedData = CreateTransactionModel.fromJson(data);

      log('$decodedData');
      return decodedData;
    } else {
      log("/////////////////////////////");
      log("${response.statusCode}");
      var error = json.decode(response.body);
      log('Error :$error');

      return null;
    }
  }
}
