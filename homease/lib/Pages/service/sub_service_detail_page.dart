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
        'totalAmount': (widget.subService.price * controller.numberOfServices.value) - discountAmount.value,
        'paymentId': response.paymentId,
        'status': 'completed',
        'bookingDate': controller.selectedDate.value?.toIso8601String(),
        'bookingTime': controller.selectedTime.value?.format(context),
        'description': controller.description.value,
        'propertyType': controller.selectedProperty.value,
        'timestamp': FieldValue.serverTimestamp(),
      });

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => Booking()));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Something went wrong!"),
        backgroundColor: Colors.red,
      ));
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Payment Failed: ${response.message}'),
      backgroundColor: Colors.red,
    ));
  }

  void _handleExternalWallet(ExternalWalletResponse response) {}

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(title: Text(widget.subService.name)),
        body: Obx(() {
          double total = (widget.subService.price * controller.numberOfServices.value) - discountAmount.value;

          return Stack(
            children: [
              SingleChildScrollView(
                padding: EdgeInsets.only(left: 16, right: 16, bottom: mediaQuery.size.height * 0.15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            widget.subService.image,
                            height: mediaQuery.size.width * 0.35,
                            width: mediaQuery.size.width * 0.35,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.subService.name,
                                style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                widget.subService.description,
                                style: TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildSectionCard(
                      title: "Type of Property",
                      child: Wrap(
                        spacing: 8,
                        children: ['Home', 'Office', 'Villa'].map((type) {
                          bool selected = controller.selectedProperty.value == type;
                          return ChoiceChip(
                            label: Text(type),
                            selected: selected,
                            onSelected: (_) => controller.setProperty(type),
                            selectedColor: Colors.deepPurpleAccent,
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
                            onPressed: controller.decreaseService,
                          ),
                          Text('${controller.numberOfServices.value}', style: const TextStyle(fontSize: 18)),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: controller.increaseService,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text("Description", style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    TextField(
                      maxLines: 3,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Describe your issue...",
                      ),
                      onChanged: controller.setDescription,
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Total: ₹${total.toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => _showPromoCodeSheet(context),
                              child: const Text('Apply Promo Code'),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => _showDateTimeSheet(context, widget.subService),
                              child: const Text('Book Now'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
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
              Text(title, style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold)),
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
            const Text("Enter Promo Code", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
                }  else if (code == 'Homeoff10') {
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
    buttonColor:const Color.fromRGBO(100, 27, 180, 1),
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
              const Text("Select your Date & Time?", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.calendar_today, color: Colors.orange),
                title: Text(
                  controller.selectedDate.value != null
                      ? DateFormat('yyyy-MM-dd').format(controller.selectedDate.value!)
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
              ListTile(
                leading: const Icon(Icons.access_time, color: Colors.green),
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
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _razorpay.open({
                    'key': 'rzp_test_Eo4qwNPYiMKynU',
                    'amount': ((subService.price * controller.numberOfServices.value - discountAmount.value) * 100)
                        .toInt(),
                    'name': subService.name,
                    'description': 'Service booking',
                    'prefill': {'contact': 'your_contact_number', 'email': 'your_email'},
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
