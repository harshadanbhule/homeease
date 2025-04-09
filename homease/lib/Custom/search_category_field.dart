import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchCategoryField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSearch;

  const SearchCategoryField({
    super.key,
    required this.controller,
    required this.onSearch,
  });


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12),
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: Icon(Icons.arrow_back, color: Colors.black87),
          ),
          SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller,
          onChanged: (_) => onSearch(),
              decoration: InputDecoration(
                hintText: 'Search Category',
                hintStyle: GoogleFonts.poppins(
                  color: Colors.grey,
                  fontSize: 14,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
          GestureDetector(
            onTap: onSearch,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Color(0xFF7B61FF),
                borderRadius: BorderRadius.all(Radius.circular(11))
              ),
              child: Icon(Icons.search, color: Colors.white, size: 18),
            ),
          )
        ],
      ),
    );
  }
}
