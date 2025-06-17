// ai_talk_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Required for SystemChrome
import 'dart:convert'; // For encoding/decoding JSON
import 'package:http/http.dart' as http; // For making API calls

// New Color Palette: Bright White and Navy Blue
const Color kNavyBlue = Color(0xFF000080); // Deep navy blue for primary elements
const Color kBrightWhite = Color(0xFFFFFFFF); // Pure white for backgrounds and main text
const Color kLightBlueAccent = Color(0xFFADD8E6); // A subtle light blue for accents or AI messages
const Color kDarkGreyText = Color(0xFF333333); // Darker grey for general text for readability
const Color kMediumGreyText = Color(0xFF666666); // Medium grey for hints or secondary text
const Color kErrorRed = Colors.redAccent; // Keeping red for errors

class AiTalkScreen extends StatefulWidget {
  const AiTalkScreen({super.key}); // Added const constructor for better performance

  @override
  _AITalkScreenState createState() => _AITalkScreenState();
}

class _AITalkScreenState extends State<AiTalkScreen> {
  final TextEditingController _textController = TextEditingController();
  final List<Map<String, dynamic>> _messages = []; // For UI display
  bool _isLoading = false;
  final ScrollController _scrollController = ScrollController(); // To auto-scroll to latest message

  // --- IMPORTANT: Paste your real API key here! ---
  // Ensure this key is kept secure and not hardcoded in production apps.
  // Consider using environment variables or a configuration file.
  final String _apiKey = "AIzaSyA2TYSH_1DQbt4BJW4vjLcd1XEj6ymKvz4"; // <<--- PASTE YOUR KEY HERE

  final List<Map<String, dynamic>> _apiHistory = [];

  @override
  void initState() {
    super.initState();

    // Set status bar icons to dark for light app bar background for consistency
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarIconBrightness: Brightness.dark, // Dark icons for light status bar
      statusBarBrightness: Brightness.dark, // For iOS (dark icons)
      statusBarColor: kBrightWhite, // Consistent status bar color
    ));


    final systemInstruction = {
      "role": "user",
      "parts": [
        {
          "text": "You are 'TK', a compassionate and supportive AI assistant for mental wellness. Your goal is to provide a safe, non-judgmental space for users to express their feelings. Provide empathetic, calming, and constructive responses. Keep your answers concise and easy to understand. Never give medical advice or a diagnosis. If the user's situation seems serious, gently suggest they speak to a qualified professional. Start the conversation by introducing yourself and asking how the user is feeling."
        }
      ]
    };

    final initialBotMessage = {
      "role": "model",
      "parts": [
        {"text": "Hello there! I'm TK, your AI companion for mental wellness. I'm here to listen. How are you feeling today?"}
      ]
    };

    _apiHistory.addAll([systemInstruction, initialBotMessage]);

    String initialMessageText = "Error: Initial message not found.";
    final parts = initialBotMessage['parts'];
    if (parts is List && parts.isNotEmpty) {
      final firstPart = parts[0];
      if (firstPart is Map<String, dynamic>) {
        final text = firstPart['text'];
        if (text is String) {
          initialMessageText = text;
        }
      }
    }
    _addAiMessage(initialMessageText); // Adds the initial AI message to the UI
  }

  void _addAiMessage(String message) {
    if (mounted) { // Check if the widget is still in the tree
      setState(() {
        _isLoading = false; // Stop loading indicator when AI message is added
        _messages.add({'text': message, 'isUser': false});
      });
      _scrollToBottom();
    }
  }

  void _addUserMessage(String message) {
    if (mounted) {
      setState(() {
        _messages.add({'text': message, 'isUser': true});
      });
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }


  void _handleSubmitted(String text) {
    final trimmedText = text.trim();
    if (trimmedText.isEmpty || _isLoading) return;
    _textController.clear();
    _addUserMessage(trimmedText);
    _processUserMessage(trimmedText);
  }

  void _processUserMessage(String userMessage) async {
    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }

    _apiHistory.add({
      "role": "user",
      "parts": [{"text": userMessage}]
    });

    // Replace with your actual Gemini API endpoint and key
    final url = Uri.parse(
        "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent?key=$_apiKey");

    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({"contents": _apiHistory});

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(response.body);
        String aiResponseText = "Sorry, I couldn't process that. Could you try rephrasing?"; // Default fallback

        if (decodedResponse is Map<String, dynamic>) {
          final candidates = decodedResponse['candidates'];
          if (candidates is List && candidates.isNotEmpty) {
            final firstCandidate = candidates[0];
            if (firstCandidate is Map<String, dynamic>) {
              final content = firstCandidate['content'];
              if (content is Map<String, dynamic>) {
                final parts = content['parts'];
                if (parts is List && parts.isNotEmpty) {
                  final firstPart = parts[0];
                  if (firstPart is Map<String, dynamic>) {
                    final text = firstPart['text'];
                    if (text is String) {
                      aiResponseText = text;
                    }
                  }
                }
              }
            }
          }
        }

        _addAiMessage(aiResponseText);
        _apiHistory.add({ // Add AI's response to history for context
          "role": "model",
          "parts": [{"text": aiResponseText}]
        });

      } else {
        String errorMessage = "Received an error from the AI service.";
        try {
          final errorBody = jsonDecode(response.body);
          if (errorBody is Map<String, dynamic> && errorBody['error'] is Map<String, dynamic>) {
            final errorDetails = errorBody['error'] as Map<String, dynamic>;
            if (errorDetails['message'] is String) {
              errorMessage = errorDetails['message'] as String;
            }
          }
          print("API Error Status: ${response.statusCode}, Body: ${response.body}");
        } catch (e) {
          errorMessage = "Error decoding API error response. Status: ${response.statusCode}";
          print("Error parsing API error details: $e. Raw response: ${response.body}");
        }
        _addAiMessage("Sorry, I encountered an error: $errorMessage");
      }
    } catch (e) {
      print("Network or other error: $e");
      _addAiMessage(
          "I'm having trouble connecting. Please check your internet connection or try again later. Error: $e");
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: kBrightWhite, // Changed to kBrightWhite
      appBar: AppBar(
        backgroundColor: kBrightWhite, // Changed to kBrightWhite
        title: Text(
          'AI Mental Wellness Chat',
          style: TextStyle(color: kNavyBlue, fontSize: screenWidth * 0.05), // Changed to kNavyBlue
        ),
        centerTitle: true,
        leading: IconButton( // Added back button
          icon: Icon(Icons.arrow_back, color: kNavyBlue), // Changed to kNavyBlue
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              controller: _scrollController, // Attach the scroll controller
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
              itemCount: _messages.length,
              itemBuilder: (_, int index) {
                final message = _messages[index];
                final textContent = message['text'] is String ? message['text'] as String : "Invalid message content";
                final isUser = message['isUser'] is bool ? message['isUser'] as bool : false;
                return _buildMessageBubble(textContent, isUser, screenWidth);
              },
            ),
          ),
          if (_isLoading)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: kNavyBlue), // Changed to kNavyBlue
                  ),
                  SizedBox(width: 10),
                  Text("TK is thinking...",
                      style: TextStyle(color: kMediumGreyText, fontStyle: FontStyle.italic))
                ],
              ),
            ),
          // Input composer separated by a subtle shadow
          Container(
            decoration: BoxDecoration(
              color: kBrightWhite, // Using kBrightWhite for card/container background
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08), // Softer shadow
                  offset: const Offset(0, -2), // Shadow above the input
                  blurRadius: 4.0,
                  spreadRadius: 1.0,
                ),
              ],
            ),
            child: _buildTextComposer(screenWidth),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(String message, bool isUser, double screenWidth) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(
          top: 8.0,
          bottom: 8.0,
          left: isUser ? screenWidth * 0.15 : 0, // More margin on the opposite side
          right: isUser ? 0 : screenWidth * 0.15, // More margin on the opposite side
        ),
        padding: EdgeInsets.symmetric(
          vertical: screenWidth * 0.03, // Slightly increased padding
          horizontal: screenWidth * 0.04,
        ),
        constraints: BoxConstraints(
          maxWidth: screenWidth * 0.75, // Adjust max width for better appearance
        ),
        decoration: BoxDecoration(
          color: isUser ? kNavyBlue : kLightBlueAccent, // User messages navy blue, AI messages light blue accent
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20.0),
            topRight: const Radius.circular(20.0),
            bottomLeft: isUser ? const Radius.circular(20.0) : const Radius.circular(8.0), // Tail
            bottomRight: isUser ? const Radius.circular(8.0) : const Radius.circular(20.0), // Tail
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08), // Softer, more subtle shadow
              blurRadius: 3.0,
              offset: const Offset(0, 1),
            )
          ],
        ),
        child: Text(
          message,
          style: TextStyle(
            color: isUser ? kBrightWhite : kDarkGreyText, // User text white, AI text dark grey
            fontSize: screenWidth * 0.04,
            height: 1.4,
          ),
        ),
      ),
    );
  }

  Widget _buildTextComposer(double screenWidth) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03, vertical: 8.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _textController,
              onSubmitted: _isLoading ? null : _handleSubmitted,
              decoration: InputDecoration(
                hintText: "Type your message...",
                hintStyle: TextStyle(fontSize: screenWidth * 0.038, color: kMediumGreyText), // Using kMediumGreyText
                border: OutlineInputBorder( // Added border for a clearer input area
                  borderRadius: BorderRadius.circular(30.0), // More rounded corners
                  borderSide: BorderSide.none, // Initially no visible border
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide(color: kLightBlueAccent, width: 1.0), // Light blue border
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide(color: kNavyBlue, width: 1.5), // Navy blue border on focus
                ),
                filled: true,
                fillColor: kLightBlueAccent.withOpacity(0.3), // Light blue background for input
                contentPadding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04, vertical: screenWidth * 0.02),
              ),
              style: TextStyle(fontSize: screenWidth * 0.04, color: kDarkGreyText), // Dark text for input
              textCapitalization: TextCapitalization.sentences,
              minLines: 1,
              maxLines: 5, // Allow multi-line input
            ),
          ),
          SizedBox(width: screenWidth * 0.02), // Spacing between input and send button
          Container(
            decoration: BoxDecoration(
              color: _isLoading ? kNavyBlue.withOpacity(0.5) : kNavyBlue, // Navy blue send button, lighter when loading
              shape: BoxShape.circle, // Circular send button
            ),
            child: IconButton(
              icon: Icon(Icons.send, size: screenWidth * 0.06, color: kBrightWhite), // Changed to kBrightWhite
              onPressed: _isLoading ? null : () => _handleSubmitted(_textController.text),
              tooltip: "Send message",
              splashRadius: screenWidth * 0.07, // Larger splash area for touch
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose(); // Dispose the scroll controller
    super.dispose();
  }
}