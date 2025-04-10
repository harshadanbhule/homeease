import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homease/Custom/search_category_field.dart';
import 'package:homease/Pages/service/sub_service_detail_page.dart';
import 'package:homease/model/service_model.dart';
import 'package:homease/model/sub_service_model.dart';

class SubServicePage extends StatefulWidget {
  final Service service;

  const SubServicePage({super.key, required this.service});

  @override
  State<SubServicePage> createState() => _SubServicePageState();
}

class _SubServicePageState extends State<SubServicePage> {
  final RxList<SubService> filteredSubServices = <SubService>[].obs;
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredSubServices.assignAll(widget.service.subServices);
  }

  void _performSearch(String query) {
    query = query.trim().toLowerCase();
    if (query.isEmpty) {
      filteredSubServices.assignAll(widget.service.subServices);
    } else {
      filteredSubServices.assignAll(
        widget.service.subServices.where((sub) =>
            sub.name.toLowerCase().contains(query)).toList(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 50),

            SearchCategoryField(
              controller: searchController,
              onSearch: () => _performSearch(searchController.text),
            ),

            const SizedBox(height: 16),

    
            Text(
              "${widget.service.name} ",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

  
            Expanded(
              child: Obx(() {
                if (filteredSubServices.isEmpty) {
                  return const Center(
                    child: Text("No matching services found."),
                  );
                }

                return ListView.builder(
                  itemCount: filteredSubServices.length,
                  itemBuilder: (context, index) {
                    final sub = filteredSubServices[index];

                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () {
                          Get.to(() => SubServiceDetailPage(subService: sub));
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                          
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(16),
                                bottomLeft: Radius.circular(16),
                              ),
                              child: Image.asset(
                                sub.image,
                                width: width * 0.28,
                                height: width * 0.28,
                                fit: BoxFit.cover,
                              ),
                            ),

             
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                 
                                    Row(
                                      children: [
                                        const Icon(Icons.star,
                                            size: 16, color: Colors.orange),
                                        const SizedBox(width: 4),
                                        Text(
                                          "4.5 (87)",
                                          style: GoogleFonts.poppins(
                                            fontSize: 12,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),

                       
                                    Text(
                                      sub.name,
                                      style: GoogleFonts.poppins(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 4),

                                    Text(
                                      "Starts From",
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        color: Colors.grey[500],
                                      ),
                                    ),
                                    const SizedBox(height: 6),

                  
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: Colors.green.shade100,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            "₹${sub.price}",
                                            style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.green[700],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            )
          ],
        ),
      ),
    );
  }
}