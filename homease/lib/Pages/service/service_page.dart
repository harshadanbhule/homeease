import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homease/Custom/search_category_field.dart';
import 'package:homease/Getx%20Controller/service_controller.dart';
import 'package:homease/Pages/service/sub_service_page.dart';

class ServicePage extends StatefulWidget {
  @override
  State<ServicePage> createState() => _ServicePageState();
}

class _ServicePageState extends State<ServicePage> {
  final controller = Get.find<ServiceController>();
  final TextEditingController searchController = TextEditingController();
  final Random random = Random();

  final List<Color> circleColors = const [
    Color.fromRGBO(255, 188, 153, 1),
    Color.fromRGBO(202, 189, 255, 1),
    Color.fromRGBO(177, 229, 252, 1),
    Color.fromRGBO(181, 235, 205, 1),
    Color.fromRGBO(255, 216, 141,1),
    Color.fromRGBO(203, 235, 164,1),
    Color.fromRGBO(251, 155, 155, 1),
    Color.fromRGBO(248, 176, 237, 1),
    Color.fromRGBO(175, 198, 255, 1),
    Color(0xFFFFF9C4),
  ];

  @override
  @override
void initState() {
  super.initState();

  // Move Rx or text controller changes here using addPostFrameCallback
  WidgetsBinding.instance.addPostFrameCallback((_) {
    controller.resetSearch(); // Assuming this updates an observable
    searchController.clear();
  });
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 15),

              // 🔍 Search Field
              SearchCategoryField(
                controller: searchController,
                onSearch: () {
                  controller.search(searchController.text);
                },
              ),

              const SizedBox(height: 16),

              // 📋 Header
              Row(
                children: const [
                  VerticalDivider(
                    thickness: 4,
                    width: 8,
                    color: Color(0xFF8268F6),
                  ),
                  SizedBox(width: 6),
                  Text(
                    "All Categories",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // 📦 Service Grid
              Expanded(
                child: Obx(() {
                  final services = controller.filteredServices;
                  return services.isEmpty
                      ? const Center(child: Text("No services found"))
                      : GridView.builder(
                          itemCount: services.length,
                          padding: const EdgeInsets.only(bottom: 20),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: 0.75,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                          itemBuilder: (context, index) {
                            final service = services[index];
                            final bgColor =
                                circleColors[index % circleColors.length];

                            return GestureDetector(
                              onTap: () async {
                                await Get.to(() => SubServicePage(service: service));
                                controller.resetSearch(); // Reset after back
                              },
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    height: 70,
                                    width: 70,
                                    decoration: BoxDecoration(
                                      color: bgColor,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(20),
                                      child: Image.asset(
                                        service.image,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    service.name,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}