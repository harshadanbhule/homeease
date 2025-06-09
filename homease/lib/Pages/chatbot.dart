import 'package:flutter/material.dart';
import 'package:homease/Custom/custom_appbar.dart';

import 'package:homease/Custom/custom_nav_bar.dart';

import 'package:homease/model/chatModel.dart';


class Chatbot extends StatefulWidget {
  const Chatbot({super.key});

  @override
  State<Chatbot> createState() => _ChatbotState();
}

class _ChatbotState extends State<Chatbot> {
   List<ChatStep> chatHistory = [];
  late ChatStep currentStep;
  bool showRetryOptions = false;

  @override
  void initState() {
    super.initState();
    currentStep = chatStart;
    chatHistory.add(currentStep);
  }

  void selectOption(ChatOption option) {
    setState(() {
      chatHistory.add(ChatStep(message: option.title, isUser: true));
      chatHistory.add(option.nextStep);
      currentStep = option.nextStep;

      showRetryOptions = option.nextStep.solution != null;
    });
  }

  void goBackToStart() {
    setState(() {
      chatHistory.add(ChatStep(message: "Yes, I want to try another option.", isUser: true));
      currentStep = chatStart;
      chatHistory.add(currentStep);
      showRetryOptions = false;
    });
  }

  Widget _buildChatBubble(String text, bool isUser) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 6),
        padding: EdgeInsets.all(12),
        constraints: BoxConstraints(maxWidth: 280),
        decoration: BoxDecoration(
          color: isUser ? Color.fromRGBO(207, 178, 238, 1) : Colors.grey.shade200,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomLeft: Radius.circular(isUser ? 16 : 0),
            bottomRight: Radius.circular(isUser ? 0 : 16),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!isUser) Icon(Icons.smart_toy, size: 20, color:Color.fromRGBO(100, 27, 180, 1),),
            if (!isUser) SizedBox(width: 6),
            Flexible(child: Text(text)),
            if (isUser) SizedBox(width: 6),
            if (isUser) Icon(Icons.person, size: 20, color: Colors.black87),
          ],
        ),
      ),
    );
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(),
       bottomNavigationBar: CustomNavBar(selectedIndex: 2),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: chatHistory.length,
                  itemBuilder: (context, index) {
                    final step = chatHistory[index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildChatBubble(step.message, step.isUser),
                        if (step.solution != null)
                          _buildChatBubble(step.solution!, false),
                      ],
                    );
                  },
                ),
              ),
              if (currentStep.options != null)
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: currentStep.options!.map((option) {
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromRGBO(100, 27, 180, 1),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: () => selectOption(option),
                      child: Text(option.title),
                    );
                  }).toList(),
                ),
              if (showRetryOptions)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Column(
                    children: [
                      Text(
                        "Did that help? Want to try another option?",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Wrap(
                        spacing: 12,
                        children: [
                          OutlinedButton.icon(
                            onPressed: goBackToStart,
                            icon: Icon(Icons.refresh),
                            label: Text("Yes, show other options"),
                          ),
                          OutlinedButton.icon(
                            onPressed: () {
                              setState(() {
                                chatHistory.add(ChatStep(
                                  message: "No, that solved my problem.",
                                  isUser: true,
                                ));
                                showRetryOptions = false;
                              });
                            },
                            icon: Icon(Icons.check_circle, color: Colors.green),
                            label: Text("No, it helped"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

final ChatStep chatStart = ChatStep(
  message: 'Hi Harshad! 👋 How can I help you today regarding our services?',
  options: [
    ChatOption(
      title: 'I want to book a service',
      nextStep: ChatStep(
        message: 'Sure! You can book a service from the "Home" tab.',
        solution: '✅ Go to Home → Select the service (e.g., cleaning, AC repair) → Choose date/time → Confirm Booking.',
      ),
    ),
    ChatOption(
      title: 'I have a payment issue',
      nextStep: ChatStep(
        message: 'Let’s resolve your payment issue.',
        solution: '✅ Make sure your payment method is valid.\n✅ For failed transactions, wait 24 hrs or contact support.\n✅ Razorpay issues? Check Razorpay dashboard.',
      ),
    ),
    ChatOption(
      title: 'I want to cancel or reschedule',
      nextStep: ChatStep(
        message: 'No problem, here’s how to cancel/reschedule:',
        solution: '✅ Go to "My Bookings" → Select booking → Tap "Cancel" or "Reschedule".\nNote: Cancellation charges may apply.',
      ),
    ),
    ChatOption(
      title: 'Service partner didn’t arrive',
      nextStep: ChatStep(
        message: 'Sorry to hear that 😞',
        solution: '✅ Please wait 10-15 mins post-slot.\n✅ Contact partner via app or tap “Need Help” in booking.\n✅ Still no response? Raise a complaint from the app.',
      ),
    ),
    ChatOption(
      title: 'How do I use the app?',
      nextStep: ChatStep(
        message: 'Here’s a quick app usage guide:',
        solution: '✅ Home: Book new services\n✅ My Bookings: View/cancel/reschedule\n✅ Profile: Edit info & manage addresses\n✅ Wallet: View transactions and offers',
      ),
    ),
  ],
);

    
