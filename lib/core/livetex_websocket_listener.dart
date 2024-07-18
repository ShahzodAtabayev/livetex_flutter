import 'package:livetex_flutter/core/livetex_message_handler.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:livetex_flutter/livetex_flutter.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class LiveTexWebSocketListener {
  static const bool logging = false;

  late LiveTexMessagesHandler _messageHandler;
  final StreamController<WebSocketChannel> _disconnectEventController = StreamController.broadcast();
  final StreamController<WebSocketChannel> _openEventController = StreamController.broadcast();
  final StreamController<Pair<WebSocketChannel, dynamic>> _failEventController = StreamController.broadcast();

  void init() {
    _messageHandler = LiveTexFlutter.instance.messagesHandler;
  }

  void onOpen(WebSocketChannel webSocketChannel) {
    if (logging) {
      debugPrint("Opened");
    }
    _openEventController.add(webSocketChannel);
  }

  void onMessage(WebSocketChannel webSocketChannel, dynamic message) {
    if (message is String) {
      _messageHandler.onMessage(message);
    }
  }

  void onClosed(
    WebSocketChannel webSocketChannel,
  ) {
    if (logging) {
      debugPrint("Closed with reason");
    }
    _disconnectEventController.add(webSocketChannel);
  }

  void onFailure(WebSocketChannel webSocketChannel, dynamic error, StackTrace? stackTrace) {
    if (logging) {
      debugPrint("Failed with reason $error");
    }
    _failEventController.add(Pair(webSocketChannel, error));
  }

  Stream<WebSocketChannel>? disconnectEvent() {
    return _disconnectEventController.stream;
  }

  Stream<WebSocketChannel>? openEvent() {
    return _openEventController.stream;
  }

  Stream<Pair<WebSocketChannel, dynamic>>? failEvent() {
    return _failEventController.stream;
  }

  void dispose() {
    _disconnectEventController.close();
    _openEventController.close();
    _failEventController.close();
  }
}
