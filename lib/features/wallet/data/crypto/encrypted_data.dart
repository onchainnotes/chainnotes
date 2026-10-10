import 'dart:convert';

class EncryptedData {
  const EncryptedData({
    required this.cipherText,
    required this.nonce,
    required this.mac,
  });

  final List<int> cipherText;
  final List<int> nonce;
  final List<int> mac;

  Map<String, dynamic> toJson() => {
    'cipherText': base64Encode(cipherText),
    'nonce': base64Encode(nonce),
    'mac': base64Encode(mac),
  };

  factory EncryptedData.fromJson(Map<String, dynamic> json) {
    return EncryptedData(
      cipherText: base64Decode(json['cipherText'] as String),
      nonce: base64Decode(json['nonce'] as String),
      mac: base64Decode(json['mac'] as String),
    );
  }

  String toJsonString() {
    return jsonEncode(toJson());
  }

  factory EncryptedData.fromJsonString(String jsonString) {
    final trimmed = jsonString.trim();
    if (trimmed.isEmpty) {
      throw FormatException('EncryptedData JSON 字符串为空');
    }
    return EncryptedData.fromJson(
      jsonDecode(trimmed) as Map<String, dynamic>,
    );
  }
}
