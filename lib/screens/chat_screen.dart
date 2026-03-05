import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/models.dart';
import '../providers/app_provider.dart';
import '../theme.dart';

class ChatScreen extends StatefulWidget {
  final String requestId;
  final String otherUserName;
  final VoidCallback? onBack;
  const ChatScreen({super.key, required this.requestId, required this.otherUserName, this.onBack});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _msgCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();

  @override
  void dispose() { _msgCtrl.dispose(); _scrollCtrl.dispose(); super.dispose(); }

  void _sendMessage(AppProvider app) {
    if (_msgCtrl.text.trim().isEmpty) return;
    app.addMessage(ChatMessage(
      id: 'm${DateTime.now().millisecondsSinceEpoch}',
      requestId: widget.requestId,
      senderId: app.user?.id ?? 'c1',
      senderName: app.user?.name ?? 'Me',
      content: _msgCtrl.text.trim(),
      timestamp: DateTime.now(),
    ));
    _msgCtrl.clear();
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollCtrl.hasClients) _scrollCtrl.animateTo(_scrollCtrl.position.maxScrollExtent, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    });
  }

  void _sendLocation(AppProvider app) {
    app.addMessage(ChatMessage(
      id: 'm${DateTime.now().millisecondsSinceEpoch}',
      requestId: widget.requestId,
      senderId: app.user?.id ?? 'c1',
      senderName: app.user?.name ?? 'Me',
      content: '📍 Location shared',
      timestamp: DateTime.now(),
      isLocation: true,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    final messages = app.getMessagesForRequest(widget.requestId);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: widget.onBack ?? () => Navigator.pop(context)),
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: AppTheme.primary.withOpacity(0.1),
              child: Text(widget.otherUserName[0], style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primary)),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.otherUserName, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                const Text('Online', style: TextStyle(fontSize: 11, color: AppTheme.success)),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.phone_outlined), onPressed: () {}),
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: messages.isEmpty
                ? Center(child: Text('No messages yet. Start the conversation!', style: TextStyle(color: Colors.grey.shade500)))
                : ListView.builder(
              controller: _scrollCtrl,
              padding: const EdgeInsets.all(16),
              itemCount: messages.length,
              itemBuilder: (context, i) {
                final msg = messages[i];
                final isOwn = msg.senderId == app.user?.id;
                return _buildBubble(msg, isOwn);
              },
            ),
          ),
          _buildInputBar(app),
        ],
      ),
    );
  }

  Widget _buildBubble(ChatMessage msg, bool isOwn) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: isOwn ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 280),
            child: Column(
              crossAxisAlignment: isOwn ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: isOwn ? AppTheme.primary : Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(18),
                      topRight: const Radius.circular(18),
                      bottomLeft: Radius.circular(isOwn ? 18 : 4),
                      bottomRight: Radius.circular(isOwn ? 4 : 18),
                    ),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 4, offset: const Offset(0, 2))],
                  ),
                  child: Text(msg.content, style: TextStyle(color: isOwn ? Colors.white : Colors.black87, fontSize: 14)),
                ),
                const SizedBox(height: 4),
                Text(DateFormat('h:mm a').format(msg.timestamp), style: TextStyle(fontSize: 10, color: Colors.grey.shade500)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputBar(AppProvider app) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      decoration: BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: Colors.grey.shade200))),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            IconButton(icon: const Icon(Icons.location_on_outlined, color: AppTheme.primary), onPressed: () => _sendLocation(app)),
            Expanded(
              child: TextField(
                controller: _msgCtrl,
                decoration: InputDecoration(
                  hintText: 'Type a message...',
                  filled: true,
                  fillColor: const Color(0xFFF3F6FA),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
                onSubmitted: (_) => _sendMessage(app),
              ),
            ),
            const SizedBox(width: 8),
            CircleAvatar(
              backgroundColor: AppTheme.primary,
              child: IconButton(icon: const Icon(Icons.send, color: Colors.white, size: 18), onPressed: () => _sendMessage(app)),
            ),
          ],
        ),
      ),
    );
  }
}