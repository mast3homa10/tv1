import 'package:get/get.dart';
import '../../../backend/models/create_transaction_model.dart';
import '../../components/timer/timer_controller.dart';

class FinalStepsController extends GetxController {
  var isStepActive = false.obs;

  var timerController = TimerController().obs;
  var transaction = CreateTransactionModel().obs;
  setTransactioin(CreateTransactionModel item) => transaction = item.obs;

  @override
  void onClose() {
    timerController.value.stop();
    super.onClose();
  }

  var currentstep = 0.obs;

  updateStep() {
    currentstep++;
    update();
  }

  var stepsLabel = [
    '1',
    '2',
    '3',
  ].obs;
}
