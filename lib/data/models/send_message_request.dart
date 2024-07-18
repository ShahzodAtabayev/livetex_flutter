
class SendMessageRequest {
  SendMessageRequest({String? message}) {
    _message = message;
  }

  SendMessageRequest.fromJson(dynamic json) {
    _message = json['message'];
  }

  String? _message;

  SendMessageRequest copyWith({String? message}) => SendMessageRequest(message: message ?? _message);

  String? get message => _message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = _message;
    return map;
  }
}
