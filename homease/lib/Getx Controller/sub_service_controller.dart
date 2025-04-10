import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SubServiceController extends GetxController {
  var selectedProperty = ''.obs;
  var numberOfServices = 1.obs;
  var description = ''.obs;
  var selectedDate = Rxn<DateTime>();
  var selectedTime = Rxn<TimeOfDay>();

  void setProperty(String type) => selectedProperty.value = type;
  void increaseService() => numberOfServices.value++;
  void decreaseService() {
    if (numberOfServices.value > 1) numberOfServices.value--;
  }

  void setDescription(String desc) => description.value = desc;
  void setDate(DateTime date) => selectedDate.value = date;
  void setTime(TimeOfDay time) => selectedTime.value = time;
}
