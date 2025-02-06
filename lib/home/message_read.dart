import 'package:flutter/material.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:permission_handler/permission_handler.dart';

class MessageReadPages extends StatefulWidget {
  const MessageReadPages({super.key});

  @override
  State<MessageReadPages> createState() => _MessageReadPagesState();
}

class _MessageReadPagesState extends State<MessageReadPages> {
  List<SmsMessage> messages = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getMessagePermission();
  }

  void getMessagePermission() async {
    if (await Permission.sms.isGranted) {
      fetchMessages();
    } else {
      if (await Permission.sms.request().isGranted) {
        fetchMessages();
      } else {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('SMS permission denied')),
        );
      }
    }
  }

  void fetchMessages() async {
    SmsQuery query = SmsQuery();
    messages = await query.getAllSms;
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Messages'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : messages.isEmpty
              ? const Center(child: Text('No Messages Found'))
              : ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    return ListTile(
                      leading: const Icon(Icons.message, color: Colors.blue),
                      title: Text(
                        message.address ?? 'Unknown Sender',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        message.body ?? 'No Content',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: Text(
                        message.date != null
                            ? '${message.date!.hour}:${message.date!.minute}'
                            : '',
                        style: const TextStyle(color: Colors.grey),
                      ),
                      onTap: () {
                        // Navigate to the new screen with the selected message
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MessageDetailPage(message: message),
                          ),
                        );
                      },
                    );
                  },
                ),
    );
  }
}

class MessageDetailPage extends StatelessWidget {
  final SmsMessage message;
  
  const MessageDetailPage({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Message Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sender: ${message.address ?? 'Unknown'}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Date: ${message.date != null ? '${message.date!.hour}:${message.date!.minute}' : 'Unknown'}',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Text(
              message.body ?? 'No Content',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
