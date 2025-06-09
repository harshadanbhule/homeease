import 'package:get/get.dart';
import 'package:homease/model/sub_service_model.dart';

class FavoriteController extends GetxController {
  var favorites = <SubService>[].obs;

  void toggleFavorite(SubService subService) {
    if (favorites.contains(subService)) {
      favorites.remove(subService);
    } else {
      favorites.add(subService);
    }
  }

  bool isFavorite(SubService subService) {
    return favorites.contains(subService);
  }
}
