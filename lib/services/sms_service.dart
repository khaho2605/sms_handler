import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:permission_handler/permission_handler.dart';

class SmsService {
  static final SmsQuery _query = SmsQuery();
  static bool _isInitialized = false;

  static Future<void> initialize() async {
    if (_isInitialized) return;

    // Request SMS permissions
    final status = await Permission.sms.request();
    if (status.isGranted) {
      _isInitialized = true;
    }
  }

  static Future<List<SmsMessage>> getInboxMessages() async {
    if (!_isInitialized) {
      await initialize();
    }
    return await _query.getAllSms;
  }
}
