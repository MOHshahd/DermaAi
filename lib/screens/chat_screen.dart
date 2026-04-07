import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'dart:io';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  final String userId = "user123"; // ممكن تغيريها حسب المستخدم
  bool _isLoading = false;

  // Speech to text
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _speechText = "";

  // Image picker
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  Future<void> sendMessage(String text, {File? image}) async {
    if (text.trim().isEmpty && image == null) return;

    setState(() {
      if (text.isNotEmpty) _messages.add({"role": "user", "text": text});
      _isLoading = true;
    });

    try {
      var uri = Uri.parse('http://127.0.0.1:8000/chat');
      var request = http.MultipartRequest('POST', uri);
      request.fields['user_id'] = userId;
      request.fields['text'] = text;

      if (image != null) {
        request.files.add(await http.MultipartFile.fromPath('image', image.path));
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        List<dynamic> paragraphs = data["paragraphs"] ?? [];
        String reply = paragraphs.join("\n\n");

        setState(() {
          _messages.add({"role": "assistant", "text": reply});
        });
      } else {
        setState(() {
          _messages.add({"role": "assistant", "text": "Error: ${response.statusCode}"});
        });
      }
    } catch (e) {
      setState(() {
        _messages.add({"role": "assistant", "text": "Error: $e"});
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildMessage(Map<String, String> msg) {
    bool isUser = msg["role"] == "user";
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        decoration: BoxDecoration(
          color: isUser ? Colors.blueGrey[200] : Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          msg["text"]!,
          style: const TextStyle(fontSize: 16, color: Colors.black87),
        ),
      ),
    );
  }

  Future<void> _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize();
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) {
            setState(() {
              _speechText = val.recognizedWords;
              _controller.text = _speechText;
            });
          },
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      sendMessage("", image: imageFile);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Derma AI Chatbot'),
        backgroundColor: Colors.blueGrey,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: false,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _buildMessage(_messages[index]);
              },
            ),
          ),
          if (_isLoading) const LinearProgressIndicator(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(_isListening ? Icons.mic : Icons.mic_none),
                  onPressed: _listen,
                ),
                IconButton(
                  icon: const Icon(Icons.image),
                  onPressed: _pickImage,
                ),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'اكتب رسالتك هنا...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : () {
                          if (_controller.text.trim().isEmpty) return;
                          sendMessage(_controller.text.trim());
                          _controller.clear();
                        },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey),
                  child: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}