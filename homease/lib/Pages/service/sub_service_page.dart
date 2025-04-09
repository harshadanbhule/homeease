import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homease/Getx%20Controller/service_controller.dart';
import 'package:homease/Pages/service/sub_service_detail_page.dart';


import 'package:homease/model/service_model.dart';


class SubServicePage extends StatelessWidget {
  final Service service;
  final controller = Get.find<ServiceController>();

  SubServicePage({required this.service});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${service.name} Options')),
      body: ListView.builder(
        itemCount: service.subServices.length,
        itemBuilder: (context, index) {
          final sub = service.subServices[index];
          
          return Card(
            child: ListTile(
              onTap: () {
  Get.to(() => SubServiceDetailPage(subService: sub));
},

              leading: Image.asset(sub.image, width: 40),
              title: Text(sub.name),
              subtitle: Text('${sub.description}\n₹${sub.price}'),
              isThreeLine: true,
              trailing: ElevatedButton(
                onPressed: () {
                  controller.addToCart(sub);
                  Get.snackbar('Added to Cart', sub.name);
                },
                child: Text('Add'),
              ),
            ),
          );
        },
      ),
    );
  }
}
