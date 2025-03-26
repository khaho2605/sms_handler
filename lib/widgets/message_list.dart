import 'package:flutter/material.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'message_card.dart';

class MessageList extends StatelessWidget {
  final List<SmsMessage> messages;
  final String? Function(String?) extractMatchingNumbers;

  const MessageList({
    super.key,
    required this.messages,
    required this.extractMatchingNumbers,
  });

  @override
  Widget build(BuildContext context) {
    if (messages.isEmpty) {
      return const Center(child: Text('No messages found'));
    }

    return ListView.builder(
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        final matchingNumbers = extractMatchingNumbers(message.body);
        return MessageCard(
          message: message,
          matchingNumbers: matchingNumbers,
        );
      },
    );
  }
}
