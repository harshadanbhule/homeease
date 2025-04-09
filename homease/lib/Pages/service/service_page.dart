import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:homease/Getx%20Controller/service_controller.dart';
import 'package:homease/Pages/service/sub_service_page.dart';

class ServicePage extends StatelessWidget {
  final controller = Get.find<ServiceController>();
  final TextEditingController searchController = TextEditingController();
  final Random random = Random();

  final List<Color> circleColors = const [
    Color(0xFFFAF3F0),
    Color(0xFFE0F7FA),
    Color(0xFFFFF3E0),
    Color(0xFFF3E5F5),
    Color(0xFFE8F5E9),
    Color(0xFFFFEBEE),
    Color(0xFFFFFDE7),
    Color(0xFFFBE9E7),
    Color(0xFFE3F2FD),
    Color(0xFFFFF9C4),
  ];

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
              // 🔙 Back Button
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: const Icon(Icons.arrow_back_ios_new_rounded, size: 22),
                  ),
                ],
              ),

              const SizedBox(height: 15),

              // 🔍 Custom Search Field
              SizedBox(
                width: MediaQuery.sizeOf(context).width - 50,
                height: 60,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: TextField(
                    controller: searchController,
                    onChanged: (value) {
                      controller.filteredServices.value = controller.allServices
                          .where((s) => s.name.toLowerCase().contains(value.toLowerCase()))
                          .toList();
                    },
                    decoration: InputDecoration(
                      suffixIcon: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            "assets/homescreen/Group 34308.svg",
                            height: 24,
                          ),
                        ],
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      fillColor: const Color.fromRGBO(248, 248, 248, 1),
                      filled: true,
                      hintText: "Search what you need...",
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // 📌 Title
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

              // 📦 Grid
              Expanded(
                child: Obx(() {
                  final services = controller.filteredServices;
                  return services.isEmpty
                      ? const Center(child: Text("No services found"))
                      : GridView.builder(
                          itemCount: services.length,
                          padding: const EdgeInsets.only(bottom: 20),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: 0.75,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                          itemBuilder: (context, index) {
                            final service = services[index];
                            final bgColor = circleColors[index % circleColors.length];

                            return GestureDetector(
                              onTap: () => Get.to(() => SubServicePage(service: service)),
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
                                      padding: const EdgeInsets.all(12),
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
