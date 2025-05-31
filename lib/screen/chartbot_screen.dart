import 'package:flutter/material.dart';
import 'dart:async';
import 'package:agrosmart/Constants/app_colors.dart';

class AgriChatbotScreen extends StatefulWidget {
  const AgriChatbotScreen({super.key});

  @override
  State<AgriChatbotScreen> createState() => _AgriChatbotScreenState();
}

class _AgriChatbotScreenState extends State<AgriChatbotScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _isTyping = false;

  // Initial suggestions for users
  final List<String> _suggestions = [
    "How to deal with crop pests?",
    "Best fertilizer for tomatoes?",
    "How much water do maize need?",
    "When to harvest wheat?",
    "How to improve soil quality?",
    "Advice on organic farming",
  ];

  @override
  void initState() {
    super.initState();
    // Add welcome message
    _addMessage(
      "Hello! I'm your AgroHelper. Ask me anything about farming, crops, or agricultural practices. How can I help you today?",
      false,
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _handleSubmitted(String text) {
    _messageController.clear();
    if (text.trim().isEmpty) return;

    // Add user message
    _addMessage(text, true);

    // Set typing indicator
    setState(() {
      _isTyping = true;
    });

    // Simulate response delay
    Timer(const Duration(milliseconds: 1200), () {
      _getBotResponse(text);
    });
  }

  void _getBotResponse(String question) {
    String response = _generateResponse(question);

    setState(() {
      _isTyping = false;
      _addMessage(response, false);
    });

    // Scroll to bottom after response
    _scrollToBottom();
  }

  String _generateResponse(String question) {
    question = question.toLowerCase();

    if (question.contains('pest') || question.contains('insect')) {
      return "For pest management, I recommend the following:\n\n"
          "1. Identify the specific pest first—different pests require different treatments\n"
          "2. Consider beneficial insects like ladybugs before using chemicals\n"
          "3. For organic control, try neem oil or insecticidal soap\n"
          "4. Use chemical pesticides only as a last resort and follow instructions carefully\n\n"
          "Would you like specific advice for certain crops or pests?";
    } else if (question.contains('water') || question.contains('irrigation')) {
      return "Proper irrigation is vital for healthy crops. In general:\n\n"
          "• Water deeply but less frequently to encourage deep root growth\n"
          "• Morning is the best time to water to reduce evaporation and disease\n"
          "• Consider drip irrigation to save water\n"
          "• Most crops need 1–1.5 inches of water per week, including rainfall\n\n"
          "Different crops have different water needs. What are you growing?";
    } else if (question.contains('fertilizer') ||
        question.contains('nutrient')) {
      return "Fertilizer recommendations depend on your soil and crop needs:\n\n"
          "• Conduct a soil test before applying fertilizer\n"
          "• Nitrogen (N) promotes leafy growth\n"
          "• Phosphorus (P) supports root and flower development\n"
          "• Potassium (K) improves plant health and disease resistance\n\n"
          "Organic options include compost, animal manure, and crop rotation.";
    } else if (question.contains('soil') || question.contains('earth')) {
      return "Healthy soil is the foundation of good farming. To improve soil quality:\n\n"
          "• Regularly add compost\n"
          "• Practice crop rotation to avoid nutrient depletion\n"
          "• Use cover crops during off-seasons\n"
          "• Minimize tilling to preserve soil structure\n"
          "• Maintain optimal pH levels (most crops prefer 6.0–7.0)\n\n"
          "Would you like information about soil testing?";
    } else if (question.contains('organic farming') ||
        question.contains('natural')) {
      return "Organic farming focuses on sustainable methods without synthetic chemicals. Key practices include:\n\n"
          "• Enhancing soil health using compost and green manure\n"
          "• Using biological pest control techniques\n"
          "• Practicing crop rotation and intercropping\n"
          "• Using natural fertilizers like compost tea and fish emulsion\n"
          "• Encouraging habitats for beneficial insects\n\n"
          "Organic certification requires meeting specific standards and a transition period.";
    } else if (question.contains('harvest') || question.contains('yield')) {
      return "Harvesting at the right time ensures maximum yield and quality. General tips:\n\n"
          "• Morning harvest is often best for many crops\n"
          "• Look for maturity indicators (color, size, texture)\n"
          "• Handle crops gently to avoid damage\n"
          "• Cure storage crops properly before storing\n\n"
          "Which crops are you planning to harvest?";
    } else if (question.contains('hello') ||
        question.contains('hi') ||
        question.contains('greeting')) {
      return "Hello! I'm your farming assistant. I can help you with questions about farming, crops, soil management, pest control, and more. What would you like to learn today?";
    } else {
      return "Thanks for your question about '$question'. While I'm still learning about agriculture, I need a bit more detail to provide an accurate answer. Can you tell me more about your specific crops, farming region, or challenges?";
    }
  }

  void _addMessage(String text, bool isUser) {
    setState(() {
      _messages.add(
        ChatMessage(text: text, isUser: isUser, time: DateTime.now()),
      );
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    // Use a small delay to ensure list is updated
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pureWhite,
      appBar: AppBar(
        backgroundColor: AppColors.pureWhite,
        title: const Text('AgroHelper'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: _showInfoDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child:
                _messages.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(8.0),
                      itemCount: _messages.length + (_isTyping ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == _messages.length) {
                          // Show typing indicator
                          return const ChatBubble(
                            text: 'Typing...',
                            isUser: false,
                            isTyping: true,
                          );
                        }
                        return ChatBubble(
                          text: _messages[index].text,
                          isUser: _messages[index].isUser,
                          isTyping: false,
                        );
                      },
                    ),
          ),
          // Suggestion chips
          if (_messages.length < 3)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                itemCount: _suggestions.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: ActionChip(
                      backgroundColor: AppColors.greenLight,
                      side: BorderSide(color: AppColors.greenLightBorder),
                      label: Text(_suggestions[index]),
                      onPressed: () {
                        _handleSubmitted(_suggestions[index]);
                      },
                    ),
                  );
                },
              ),
            ),
          // Input section
          Container(
            decoration: BoxDecoration(
              color: AppColors.pureWhite,
              boxShadow: [
                BoxShadow(
                  color: AppColors.mediumGrey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, -1),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.camera_alt),
                  color: AppColors.greenMedium,
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Plant image analysis coming soon!'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                ),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Ask about farming, crops, or pests...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: AppColors.lightGrey,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8.0,
                      ),
                    ),
                    textCapitalization: TextCapitalization.sentences,
                    onSubmitted: _handleSubmitted,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send_rounded, color: AppColors.greenMedium),
                  onPressed: () => _handleSubmitted(_messageController.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.agriculture, size: 80, color: AppColors.secondary),
          const SizedBox(height: 16),
          Text(
            'Your Farming Assistant',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.greenMedium,
            ),
          ),
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.0),
            child: Text(
              'Ask me anything about farming, crops, and agricultural practices',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.subtext, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  void _showInfoDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: AppColors.pureWhite,
            title: Row(
              children: [
                Icon(Icons.agriculture, color: AppColors.greenMedium),
                const SizedBox(width: 8),
                Expanded(
                  child: const Text(
                    'About AgroHelper',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            content: const Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'The assistant provides guidance on:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                BulletPoint('Crop selection and management'),
                BulletPoint('Pest and disease control'),
                BulletPoint('Soil health and fertilizer use'),
                BulletPoint('Irrigation techniques'),
                BulletPoint('Sustainable farming practices'),
                SizedBox(height: 12),
                Text(
                  'While we strive to provide accurate information, please consult with local agricultural experts for region-specific advice tailored to your conditions.',
                  style: TextStyle(fontStyle: FontStyle.italic, fontSize: 12),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'Close',
                  style: TextStyle(color: AppColors.greenMedium),
                ),
              ),
            ],
          ),
    );
  }
}

class BulletPoint extends StatelessWidget {
  final String text;

  const BulletPoint(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime time;

  ChatMessage({required this.text, required this.isUser, required this.time});
}

class ChatBubble extends StatefulWidget {
  final String text;
  final bool isUser;
  final bool isTyping;

  const ChatBubble({
    super.key,
    required this.text,
    required this.isUser,
    required this.isTyping,
  });

  @override
  State<ChatBubble> createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment:
            widget.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!widget.isUser) ...[
            CircleAvatar(
              backgroundColor: AppColors.greenMedium,
              child: const Icon(
                Icons.agriculture,
                color: AppColors.pureWhite,
                size: 20,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color:
                    widget.isUser
                        ? AppColors.info.withOpacity(0.1)
                        : AppColors.greenLight,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color:
                      widget.isUser
                          ? AppColors.info.withOpacity(0.3)
                          : AppColors.greenLightBorder,
                  width: 1,
                ),
              ),
              child:
                  widget.isTyping
                      ? SizedBox(
                        width: 50,
                        child: Row(
                          children: [_buildDot(1), _buildDot(2), _buildDot(3)],
                        ),
                      )
                      : Text(
                        widget.text,
                        style: TextStyle(color: AppColors.dark),
                      ),
            ),
          ),
          if (widget.isUser) const SizedBox(width: 8),
          if (widget.isUser)
            CircleAvatar(
              backgroundColor: AppColors.info,
              child: const Icon(
                Icons.person,
                color: AppColors.pureWhite,
                size: 20,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDot(int index) {
    return Expanded(
      child: Center(
        child: AnimatedBuilder(
          animation: CurvedAnimation(
            parent: _controller,
            curve: Interval(
              (index - 1) * 0.3,
              index * 0.3,
              curve: Curves.easeIn,
            ),
          ),
          builder: (context, child) {
            return Container(
              height: 8,
              width: 8,
              decoration: BoxDecoration(
                color: AppColors.greenMedium.withOpacity(_controller.value),
                shape: BoxShape.circle,
              ),
            );
          },
        ),
      ),
    );
  }
}
