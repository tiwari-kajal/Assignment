import 'dart:async';
import 'dart:io';

class NetworkCheck {
  Future<bool> check() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].address.isNotEmpty) return true;
    } on SocketException catch (_) {
      return false;
    }
    return false;
  }
}

