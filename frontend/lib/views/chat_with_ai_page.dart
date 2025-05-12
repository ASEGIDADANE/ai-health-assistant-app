import 'package:flutter/material.dart';
import 'package:frontend/view_models/chat_viewModel.dart';
import 'package:provider/provider.dart';


class ChatWithAIPage extends StatelessWidget {
  const ChatWithAIPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return ChangeNotifierProvider(
    //   create: (_) => ChatViewModel(),
    //   child: const _ChatWithAIContent(),
    // );
    return const _ChatWithAIContent();
  }
}

class _ChatWithAIContent extends StatefulWidget {
  const _ChatWithAIContent({Key? key}) : super(key: key);

  @override
  State<_ChatWithAIContent> createState() => _ChatWithAIContentState();
}  

class _ChatWithAIContentState extends State<_ChatWithAIContent> {
  final TextEditingController _controller = TextEditingController();

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    context.read<ChatViewModel>().sendMessage(text);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Colors.green[100],
            child: const Text('H', style: TextStyle(color: Colors.white)),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('Health Assistant', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
            SizedBox(height: 2),
            Text('AI-powered health guidance', style: TextStyle(fontSize: 13, color: Colors.blueGrey)),
          ],
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Row(
              children: [
                Icon(Icons.circle, color: Colors.green, size: 12),
                SizedBox(width: 4),
                Text('Online', style: TextStyle(color: Colors.green, fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<ChatViewModel>(
              builder: (context, viewModel, child) {
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  itemCount: viewModel.messages.length + (viewModel.isLoading ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == viewModel.messages.length) {
                      // Show loading indicator
                      return const Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                    
                    final msg = viewModel.messages[index];
                    return Align(
                      alignment: msg.isAI ? Alignment.centerLeft : Alignment.centerRight,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: msg.isAI ? Colors.white : Colors.blue[50],
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(18),
                            topRight: const Radius.circular(18),
                            bottomLeft: Radius.circular(msg.isAI ? 4 : 18),
                            bottomRight: Radius.circular(msg.isAI ? 18 : 4),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (msg.isAI)
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 12,
                                    backgroundColor: Colors.green[100],
                                    child: const Text('AI', style: TextStyle(fontSize: 12, color: Colors.black)),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(msg.time, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                                ],
                              ),
                            if (!msg.isAI)
                              Align(
                                alignment: Alignment.centerRight,
                                child: Text(msg.time, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                              ),
                            const SizedBox(height: 4),
                            Text(msg.message, style: const TextStyle(fontSize: 15)),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey[200]!)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Type your health question here...',
                      border: InputBorder.none,
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                GestureDetector(
                  onTap: _sendMessage,
                  child: Container(
                    margin: const EdgeInsets.only(left: 8),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Icon(Icons.send, color: Colors.white, size: 28),
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 8.0, top: 2),
            child: Text(
              'This AI assistant provides general guidance only. For medical emergencies, please call emergency services.',
              style: TextStyle(fontSize: 12, color: Colors.blueGrey),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
