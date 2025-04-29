import 'package:flutter/material.dart';
import 'dart:async';

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

  // Pre-defined suggestions for users
  final List<String> _suggestions = [
    "How to deal with crop pests?",
    "Best fertilizers for tomatoes?",
    "How much water do maize crops need?",
    "When to harvest wheat?",
    "How to improve soil quality?",
    "Tips for organic farming",
  ];

  @override
  void initState() {
    super.initState();
    // Add welcome message
    _addMessage(
      "Hello! I'm your AgroSmart Assistant. Ask me any questions about farming, crops, or agricultural practices. How can I help you today?",
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

  void _getBotResponse(String query) {
    String response = _generateResponse(query);

    setState(() {
      _isTyping = false;
      _addMessage(response, false);
    });

    // Scroll to bottom after response
    _scrollToBottom();
  }

  String _generateResponse(String query) {
    // This would be replaced with a real AI/ML model or API call
    query = query.toLowerCase();

    if (query.contains('pest') || query.contains('insect')) {
      return "For pest management, I recommend an integrated approach:\n\n"
          "1. Identify the specific pest first - different pests require different treatments\n"
          "2. Consider beneficial insects like ladybugs before chemical options\n"
          "3. For organic control, try neem oil or insecticidal soap\n"
          "4. Only use chemical pesticides as a last resort and follow label instructions carefully\n\n"
          "Would you like specific advice for a particular crop or pest?";
    } else if (query.contains('water') || query.contains('irrigation')) {
      return "Proper irrigation is essential for crop health. Generally:\n\n"
          "• Water deeply but infrequently to encourage deep root growth\n"
          "• Morning is the best time to water to reduce evaporation and fungal issues\n"
          "• Consider drip irrigation to conserve water\n"
          "• For most crops, provide 1-1.5 inches of water per week including rainfall\n\n"
          "Different crops have different water needs. Which crop are you growing?";
    } else if (query.contains('fertilizer') || query.contains('nutrient')) {
      return "Fertilizer recommendations depend on your soil and crop needs:\n\n"
          "• Conduct a soil test before applying fertilizers\n"
          "• Nitrogen (N) promotes leaf growth\n"
          "• Phosphorus (P) supports root and flower development\n"
          "• Potassium (K) enhances overall plant health and disease resistance\n\n"
          "Organic options include compost, manure, and crop rotation with legumes.";
    } else if (query.contains('soil') || query.contains('dirt')) {
      return "Healthy soil is the foundation of successful farming. To improve soil quality:\n\n"
          "• Add organic matter like compost regularly\n"
          "• Practice crop rotation to prevent nutrient depletion\n"
          "• Consider cover crops during off-seasons\n"
          "• Minimize tillage to preserve soil structure\n"
          "• Maintain proper pH levels (most crops prefer 6.0-7.0)\n\n"
          "Would you like information about testing your soil?";
    } else if (query.contains('organic') || query.contains('natural')) {
      return "Organic farming focuses on sustainable practices without synthetic chemicals. Key practices include:\n\n"
          "• Building soil health through compost and green manures\n"
          "• Using biological pest control methods\n"
          "• Implementing crop rotation and polyculture\n"
          "• Applying natural fertilizers like compost tea and fish emulsion\n"
          "• Creating habitat for beneficial insects\n\n"
          "Getting certified organic requires meeting specific standards and a transition period.";
    } else if (query.contains('harvest') || query.contains('picking')) {
      return "Harvesting at the right time maximizes both yield and quality. General tips:\n\n"
          "• Morning harvesting is often best for many crops\n"
          "• Look for crop-specific indicators of readiness (color, size, texture)\n"
          "• Handle produce gently to avoid damage\n"
          "• For storage crops, cure properly before storing\n\n"
          "Which specific crop are you looking to harvest?";
    } else if (query.contains('hello') ||
        query.contains('hi') ||
        query.contains('hey')) {
      return "Hello! I'm your agricultural assistant. I can help with questions about farming, crops, soil management, pest control, and more. What would you like to know today?";
    } else {
      return "Thank you for your question about '$query'. While I'm continuously learning about agriculture, I'd need more specific details to provide the most helpful answer. Could you tell me more about your specific crop, growing region, or particular challenge you're facing?";
    }
  }

  void _addMessage(String text, bool isUser) {
    setState(() {
      _messages.add(
        ChatMessage(text: text, isUser: isUser, timestamp: DateTime.now()),
      );
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    // Use a short delay to ensure the list has updated
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('AgroSmart Assistant'),
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
                      backgroundColor: Colors.green.shade50,
                      side: BorderSide(color: Colors.green.shade200),
                      label: Text(_suggestions[index]),
                      onPressed: () {
                        _handleSubmitted(_suggestions[index]);
                      },
                    ),
                  );
                },
              ),
            ),
          // Input field
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
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
                  color: Colors.green.shade700,
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
                      fillColor: Colors.grey.shade100,
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
                  icon: Icon(Icons.send_rounded, color: Colors.green.shade700),
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
          Icon(Icons.agriculture, size: 80, color: Colors.green.shade200),
          const SizedBox(height: 16),
          Text(
            'Your Agricultural Assistant',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.green.shade700,
            ),
          ),
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.0),
            child: Text(
              'Ask me anything about farming, crops, and agricultural practices',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 16),
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
            backgroundColor: Colors.white,
            title: Row(
              children: [
                Icon(Icons.agriculture, color: Colors.green.shade700),
                const SizedBox(width: 8),
                Expanded(
                  child: const Text(
                    'About AgroSmart Assistant',
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
                  'This assistant provides guidance on:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                BulletPoint('Crop selection and management'),
                BulletPoint('Pest and disease control'),
                BulletPoint('Soil health and fertilization'),
                BulletPoint('Irrigation practices'),
                BulletPoint('Sustainable farming techniques'),
                SizedBox(height: 12),
                Text(
                  'While we strive to provide accurate information, please consult with local agricultural experts for advice specific to your region and conditions.',
                  style: TextStyle(fontStyle: FontStyle.italic, fontSize: 12),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'Close',
                  style: TextStyle(color: Colors.green.shade700),
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
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
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
              backgroundColor: Colors.green.shade700,
              child: const Icon(
                Icons.agriculture,
                color: Colors.white,
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
                    widget.isUser ? Colors.blue.shade100 : Colors.green.shade50,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color:
                      widget.isUser
                          ? Colors.blue.shade200
                          : Colors.green.shade200,
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
                        style: TextStyle(
                          color:
                              widget.isUser ? Colors.black87 : Colors.black87,
                        ),
                      ),
            ),
          ),
          if (widget.isUser) const SizedBox(width: 8),
          if (widget.isUser)
            CircleAvatar(
              backgroundColor: Colors.blue.shade700,
              child: const Icon(Icons.person, color: Colors.white, size: 20),
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
                color: Colors.green.shade700.withOpacity(_controller.value),
                shape: BoxShape.circle,
              ),
            );
          },
        ),
      ),
    );
  }
}
