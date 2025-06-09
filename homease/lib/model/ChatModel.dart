class ChatStep {
  final String message;
  final List<ChatOption>? options;
  final String? solution;
  final bool isUser;

  ChatStep({
    required this.message,
    this.options,
    this.solution,
    this.isUser = false,
  });
}

class ChatOption {
  final String title;
  final ChatStep nextStep;

  ChatOption({required this.title, required this.nextStep});
}