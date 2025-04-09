import 'package:get/get.dart';
import 'package:homease/model/service_model.dart';
import 'package:homease/service%20data/service_data.dart';

class ServiceController extends GetxController {
  final allServices = <Service>[].obs;
  final filteredServices = <Service>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadServices();
  }

  void loadServices() {
    allServices.assignAll(services); // ✅ Using your existing list
    filteredServices.assignAll(allServices);
  }

  void search(String query) {
    if (query.trim().isEmpty) {
      filteredServices.assignAll(allServices);
    } else {
      filteredServices.assignAll(
        allServices.where((s) => s.name.toLowerCase().contains(query.toLowerCase())),
      );
    }
  }

  void resetSearch() {
    filteredServices.assignAll(allServices);
  }
}
