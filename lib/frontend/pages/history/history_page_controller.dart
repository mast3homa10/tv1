import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

class HistoryPageController extends GetxController {
  var isTransactionExist = false.obs;
  updateTransactionExist(bool value) => isTransactionExist = value.obs;

  var transactionList = [].obs;
  updateTransactionList(var item) => transactionList.add(item);
  final _storage = const FlutterSecureStorage();
}
