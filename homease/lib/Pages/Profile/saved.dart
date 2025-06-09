import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homease/Getx%20Controller/favorite_controller.dart';
import 'package:homease/Pages/service/sub_service_detail_page.dart';
import 'package:homease/model/sub_service_model.dart';

class Saved extends StatefulWidget {
  const Saved({super.key});

  @override
  State<Saved> createState() => _SavedState();
}

class _SavedState extends State<Saved> {
  final FavoriteController favoriteController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Saved Services"),
      ),
      body: Obx(() {
        if (favoriteController.favorites.isEmpty) {
          return const Center(
            child: Text(
              "No favorites added yet.",
              style: TextStyle(fontSize: 16),
            ),
          );
        }

        return ListView.builder(
          itemCount: favoriteController.favorites.length,
          itemBuilder: (context, index) {
            SubService sub = favoriteController.favorites[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
              child: ListTile(
                contentPadding: const EdgeInsets.all(12),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    sub.image,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
                title: Text(
                  sub.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                subtitle: Text(
                  "Starts from ₹${sub.price}",
                  style: TextStyle(color: Colors.green[700]),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    favoriteController.toggleFavorite(sub);
                  },
                ),
                onTap: () {
                  Get.to(() => SubServiceDetailPage(subService: sub));
                },
              ),
            );
          },
        );
      }),
    );
  }
}
