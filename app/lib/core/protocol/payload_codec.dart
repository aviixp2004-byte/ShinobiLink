import 'dart:convert';

class PayloadCodec {
  static String encode(Map<String, dynamic> data) {
    return jsonEncode(data);
  }

  static Map<String, dynamic> decode(String payload) {
    return jsonDecode(payload) as Map<String, dynamic>;
  }
}
