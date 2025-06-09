import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homease/Getx%20Controller/sub_service_controller.dart';
import 'package:homease/Pages/booking.dart';
import 'package:homease/model/sub_service_model.dart';
import 'package:intl/intl.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class SubServiceDetailPage extends StatefulWidget {
  final SubService subService;

  const SubServiceDetailPage({super.key, required this.subService});

  @override
  State<SubServiceDetailPage> createState() => _SubServiceDetailPageState();
}

class _SubServiceDetailPageState extends State<SubServiceDetailPage> {
  final controller = Get.put(SubServiceController());
  final TextEditingController promoCodeController = TextEditingController();
  final _razorpay = Razorpay();
  RxInt discountAmount = 0.obs;

  @override
  void initState() {
    super.initState();
    controller.setProperty("Home");
    controller.setDescription("");
    controller.numberOfServices.value = 1;

    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    _razorpay.clear();
    promoCodeController.dispose();
    super.dispose();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    try {
      await FirebaseFirestore.instance.collection('orders').add({
        'serviceId': widget.subService.id,
        'serviceName': widget.subService.name,
        'serviceImage': widget.subService.image,
        'userId': FirebaseAuth.instance.currentUser?.uid,
        'quantity': controller.numberOfServices.value,
        'totalAmount':
            (widget.subService.price * controller.numberOfServices.value) -
            discountAmount.value,
        'paymentId': response.paymentId,
        'status': 'completed',
        'bookingDate': controller.selectedDate.value?.toIso8601String(),
        'bookingTime': controller.selectedTime.value?.format(context),
        'description': controller.description.value,
        'propertyType': controller.selectedProperty.value,
        'timestamp': FieldValue.serverTimestamp(),
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => Booking()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Something went wrong!"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Payment Failed: ${response.message}'),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {}

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Obx(() {
          double total =
              (widget.subService.price * controller.numberOfServices.value) -
              discountAmount.value;

          return Stack(
            children: [
              // 🌆 Background Image
              Positioned.fill(
                child: Image.asset(widget.subService.image, fit: BoxFit.cover),
              ),

              // 🔲 Blur Overlay
              Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                  child: Container(color: Colors.black.withOpacity(0.50)),
                ),
              ),

              // 📜 Foreground UI with scrollable content
              CustomScrollView(
                slivers: [
                  
                  SliverAppBar(
                    pinned: true,
                    expandedHeight: mediaQuery.size.width * 0.65,
                    backgroundColor: Colors.transparent,
                    flexibleSpace: FlexibleSpaceBar(
                      
                      title: Text(
                        widget.subService.name,
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      background: Container(), // We already show image behind
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          
                          const SizedBox(height: 20),
                          _buildSectionCard(
                            title: "Type of Property",
                            child: Wrap(
                              spacing: 20,
                              children:
                                  ['Home', 'Office', 'Villa'].map((type) {
                                    bool selected =
                                        controller.selectedProperty.value ==
                                        type;
                                    IconData icon;
                                    switch (type) {
                                      case 'Home':
                                        icon = Icons.home_outlined;
                                        break;
                                      case 'Office':
                                        icon = Icons.apartment;
                                        break;
                                      case 'Villa':
                                        icon = Icons.villa;
                                        break;
                                      default:
                                        icon = Icons.home;
                                    }

                                    return Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ChoiceChip(
                                          label: Icon(
                                            icon,
                                            size: 28,
                                            color:
                                                selected
                                                    ? Colors.white
                                                    : const Color.fromARGB(
                                                      255,
                                                      188,
                                                      188,
                                                      188,
                                                    ),
                                          ),
                                          selected: selected,
                                          onSelected:
                                              (_) =>
                                                  controller.setProperty(type),
                                          selectedColor:
                                              Colors.deepPurpleAccent,
                                          backgroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                          ),
                                          padding: const EdgeInsets.all(12),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          type,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color:
                                                selected
                                                    ? Colors.deepPurple
                                                    : Colors.black,
                                            fontWeight:
                                                selected
                                                    ? FontWeight.bold
                                                    : FontWeight.normal,
                                          ),
                                        ),
                                      ],
                                    );
                                  }).toList(),
                            ),
                          ),
                          const SizedBox(height: 10),
                          _buildSectionCard(
                            title: "Number of Services",
                            child: Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove),
                                  iconSize: 15,
                                  onPressed: controller.decreaseService,
                                ),
                                Text(
                                  '${controller.numberOfServices.value}',
                                  style: const TextStyle(fontSize: 15),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add),
                                  iconSize: 15,
                                  onPressed: controller.increaseService,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          _buildSectionCard(
                            title: "Description",
                            child: TextField(
                              maxLines: 3,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: "Describe your issue...",
                              ),
                              onChanged: controller.setDescription,
                            ),
                          ),
                          const SizedBox(height: 120),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // 🟦 Bottom Action Bar
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    ),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(color: Colors.black12, blurRadius: 10),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Total: ₹${total.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => _showPromoCodeSheet(context),
                              child: const Text('Apply Promo Code'),
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                      Colors.deepPurple,
                                    ),
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                      Colors.white,
                                    ),
                                shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder
                                >(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      12,
                                    ), // set corner radius
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton(
                              onPressed:
                                  () => _showDateTimeSheet(
                                    context,
                                    widget.subService,
                                  ),
                              child: const Text('Book Now'),
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                      Colors.deepPurple,
                                    ),
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                      Colors.white,
                                    ),
                                shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder
                                >(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      12,
                                    ), // set corner radius
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildSectionCard({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 224, 230, 255),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 30,
                width: 6,
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(202, 189, 255, 1),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }

  void _showPromoCodeSheet(BuildContext context) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Enter Promo Code",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: promoCodeController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Promo Code",
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                final code = promoCodeController.text.trim();
                String title = "Promo Code";
                String message = "";
                if (code == 'Homeoff25') {
                  discountAmount.value = 100;
                  message = "Homeoff25 Promo code applied";
                } else if (code == 'Homeoff15') {
                  discountAmount.value = 50;
                  message = "Homeoff15 Promo code applied";
                } else if (code == 'Homeoff10') {
                  discountAmount.value = 25;
                  message = "Homeoff10 Promo code applied";
                } else {
                  discountAmount.value = 0;
                }
                Get.back();
                Get.defaultDialog(
                  title: title,
                  middleText: message,
                  textConfirm: "OK",
                  buttonColor: const Color.fromRGBO(100, 27, 180, 1),
                  onConfirm: () => Get.back(),
                );
              },
              child: const Text("Apply"),
            ),
          ],
        ),
      ),
    );
  }

  void _showDateTimeSheet(BuildContext context, SubService subService) {
    Get.bottomSheet(
      Obx(() {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    height: 30,
                    width: 6,
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(202, 189, 255, 1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  SizedBox(width: 15),
                  Text(
                    "Select your Date & Time?",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(255, 188, 153, 1),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: ListTile(
                  leading: const Icon(
                    Icons.calendar_today,
                    color: Colors.black,
                  ),
                  title: Text(
                    controller.selectedDate.value != null
                        ? DateFormat(
                          'yyyy-MM-dd',
                        ).format(controller.selectedDate.value!)
                        : "Select your Date",
                  ),
                  onTap: () async {
                    final pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                    );
                    if (pickedDate != null) controller.setDate(pickedDate);
                  },
                ),
              ),
              SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(181, 228, 202, 1),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: ListTile(
                  leading: const Icon(Icons.access_time, color: Colors.black),
                  title: Text(
                    controller.selectedTime.value != null
                        ? controller.selectedTime.value!.format(context)
                        : "Select Time",
                  ),
                  onTap: () async {
                    final pickedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (pickedTime != null) controller.setTime(pickedTime);
                  },
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _razorpay.open({
                    'key': 'rzp_test_Eo4qwNPYiMKynU',
                    'amount':
                        ((subService.price * controller.numberOfServices.value -
                                    discountAmount.value) *
                                100)
                            .toInt(),
                    'name': subService.name,
                    'description': 'Service booking',
                    'prefill': {
                      'contact': 'your_contact_number',
                      'email': 'your_email',
                    },
                  });
                },
                child: const Text('Proceed to Payment'),
              ),
            ],
          ),
        );
      }),
    );
  }
}
