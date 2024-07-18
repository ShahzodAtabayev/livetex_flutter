class ChatEvent {
  final ChatEventType? eventType;
  final dynamic data;

  ChatEvent({required this.eventType, required this.data});
}

enum ChatEventType {
  state,
  typing,
  department,
  result,
  attributes,
  attributesRequest,
  departmentRequest,
  update,
  employeeTyping,
  getHistory,
  rating,
  buttonPressed,
  unknown
}
