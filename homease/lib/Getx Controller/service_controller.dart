import 'package:get/get.dart';
import 'package:homease/model/service_model.dart';
import 'package:homease/model/sub_service_model.dart';
import 'package:homease/service%20data/service_data.dart';

class ServiceController extends GetxController {
  RxList<Service> allServices = <Service>[].obs;
  RxList<SubService> cart = <SubService>[].obs;
  RxList<Service> filteredServices = <Service>[].obs;

  @override
  void onInit() {
    loadServices();
    super.onInit();
  }

  void loadServices() {
    allServices.assignAll(services); // from service_data.dart
    filteredServices.assignAll(services);
  }

  void addToCart(SubService item) {
    cart.add(item);
  }

  double get total => cart.fold(0.0, (sum, item) => sum + item.price);
}
