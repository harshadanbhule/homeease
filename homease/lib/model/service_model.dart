import 'sub_service_model.dart';

class Service {
  final String id;
  final String name;
  final String image;
  final List<SubService> subServices;

  Service({
    required this.id,
    required this.name,
    required this.image,
    required this.subServices,
  });
}