import 'package:flutter/material.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import '../services/sms_service.dart';
import '../services/api_service.dart';
import '../widgets/message_list.dart';
import '../widgets/loading_indicator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<SmsMessage> messages = [];
  bool isLoading = false;
  final RegExp pattern = RegExp(r'ABC\s+(\d{6})\s+(\d{6})');

  @override
  void initState() {
    super.initState();
    _initializeSmsService();
  }

  Future<void> _initializeSmsService() async {
    await SmsService.initialize();
    await _loadMessages();
  }

  Future<void> _loadMessages() async {
    setState(() {
      isLoading = true;
    });

    try {
      final inboxMessages = await SmsService.getInboxMessages();
      setState(() {
        messages = inboxMessages;
      });

      await _processMessages(inboxMessages);
    } catch (e) {
      _showError('Error loading messages: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _processMessages(List<SmsMessage> messages) async {
    for (final message in messages) {
      final match = pattern.firstMatch(message.body ?? '');
      if (match != null) {
        final firstNumber = match.group(1);
        final secondNumber = match.group(2);
        if (firstNumber != null && secondNumber != null) {
          await _sendMatchedNumbers(
            numbers: '$firstNumber $secondNumber',
            phoneNumber: message.address ?? 'Unknown',
          );
        }
      }
    }
  }

  Future<void> _sendMatchedNumbers({
    required String numbers,
    required String phoneNumber,
  }) async {
    final success = await ApiService.sendMatchedNumbers(
      numbers: numbers,
      phoneNumber: phoneNumber,
    );

    if (success) {
      _showSuccess('Successfully sent numbers: $numbers');
    } else {
      _showError('Failed to send numbers to endpoint');
    }
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  String? _extractMatchingNumbers(String? content) {
    if (content == null) return null;
    final match = pattern.firstMatch(content);
    if (match != null) {
      final firstNumber = match.group(1);
      final secondNumber = match.group(2);
      return '$firstNumber $secondNumber';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('SMS Handler'),
      ),
      body: isLoading
          ? const LoadingIndicator()
          : MessageList(
              messages: messages,
              extractMatchingNumbers: _extractMatchingNumbers,
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _loadMessages,
        tooltip: 'Refresh Messages',
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
