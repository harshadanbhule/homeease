import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homease/Getx%20Controller/sub_service_controller.dart';
import 'package:homease/Pages/booking.dart';
import 'package:homease/model/sub_service_model.dart';
import 'package:intl/intl.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class SubServiceDetailPage extends StatefulWidget {
  final SubService subService;

  SubServiceDetailPage({Key? key, required this.subService}) : super(key: key);

  @override
  _SubServiceDetailPageState createState() => _SubServiceDetailPageState();
}

class _SubServiceDetailPageState extends State<SubServiceDetailPage> {
  final controller = Get.put(SubServiceController());
  final TextEditingController promoCodeController = TextEditingController();
  var _razorpay = Razorpay();
  RxInt discountAmount = 0.obs;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.setProperty("Home");
      controller.setDescription("");
      controller.numberOfServices.value = 1;
    });

    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Payment Failed: ${response.message}'),
      backgroundColor: Colors.red,
    ));
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

  void _handleExternalWallet(ExternalWalletResponse response) {}

  @override
  void dispose() {
    _razorpay.clear();
    promoCodeController.dispose();
    super.dispose();
  }

 @override
Widget build(BuildContext context) {
  final mediaQuery = MediaQuery.of(context);
  final mediaQueryWidth = mediaQuery.size.width;
  final mediaQueryHeight = mediaQuery.size.height;

  return GestureDetector(
    onTap: () => FocusScope.of(context).unfocus(),
    child: Scaffold(
      appBar: AppBar(title: Text(widget.subService.name)),
     body: Obx(() {
  double total = (widget.subService.price * controller.numberOfServices.value) - discountAmount.value;
  final mediaQuery = MediaQuery.of(context).size;

  return Stack(
    children: [
      // Scrollable content
      SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(16, 16, 16, mediaQuery.height * 0.12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(widget.subService.image, height: 180, fit: BoxFit.cover),
            SizedBox(height: 20),
            Text(widget.subService.name, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text(widget.subService.description, style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            Text('Type of Property', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
            SizedBox(height: 20),
            Text('Number of Services', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Row(
              children: [
                IconButton(icon: Icon(Icons.remove), onPressed: controller.decreaseService),
                Text('${controller.numberOfServices.value}', style: TextStyle(fontSize: 18)),
                IconButton(icon: Icon(Icons.add), onPressed: controller.increaseService),
              ],
            ),
            SizedBox(height: 20),
            Text('Description'),
            SizedBox(height: 10),
            TextField(
              maxLines: 3,
              decoration: InputDecoration(border: OutlineInputBorder(), hintText: "Describe your issue..."),
              onChanged: controller.setDescription,
            ),
          ],
        ),
      ),

      // Fixed bottom container
      Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Total: ₹${total.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _showPromoCodeSheet(context),
                      child: Text('Apply Promo Code'),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _showDateTimeSheet(context, widget.subService),
                      child: Text('Book Now'),
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
              decoration: const InputDecoration(border: OutlineInputBorder(), hintText: "Promo Code"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                String code = promoCodeController.text.trim();
                if (code == 'Harshad007') {
                  discountAmount.value = 100;
                } else if (code == 'Anbhule007') {
                  discountAmount.value = 200;
                } else {
                  discountAmount.value = 0;
                }
                Get.back();
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
                title: Text(controller.selectedDate.value != null
                    ? DateFormat('yyyy-MM-dd').format(controller.selectedDate.value!)
                    : "Select your Date"),
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
                title: Text(controller.selectedTime.value != null
                    ? controller.selectedTime.value!.format(context)
                    : "Select Time"),
                onTap: () async {
                  final TimeOfDay? pickedTime = await showTimePicker(
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
                    'amount': ((subService.price * controller.numberOfServices.value - discountAmount.value) * 100).toInt(),
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