import 'dart:convert';

class WSMessage {
  Object data;
  String tag;

  // constructor
  WSMessage({
    required this.tag,
    required this.data,
  });

  // Create from json string
  factory WSMessage.fromJson(String str) => WSMessage.fromMap(json.decode(str));

  static fromMap(decode) {
    return WSMessage(
      tag: decode['tag'],
      data: decode['data'],
    );
  }
}
