import 'package:livetex_flutter/core/enums/livetex_connection_state.dart';
import 'package:livetex_flutter/core/livetex_websocket_listener.dart';
import 'package:livetex_flutter/data/models/auth_response_entity.dart';
import 'package:livetex_flutter/data/models/auth_data.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:livetex_flutter/core/api_manager.dart';
import 'package:livetex_flutter/livetex_flutter.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'dart:async';
import 'dart:io';

class NetworkManager {
  static NetworkManager? _instance;
  late final BehaviorSubject<LiveTexConnectionState> _connectionStateSubject;
  late final LiveTexWebSocketListener _websocketListener;
  final String authEndpoint;
  String? _wsEndpoint;
  String? _uploadEndpoint;
  final String touchpoint;
  String? _lastVisitorToken;
  final String? deviceToken;
  final String? deviceType;
  WebSocketChannel? _webSocket;
  late final ApiManager _apiManager;
  AuthData? authData;

  NetworkManager._({
    required String host,
    required this.authEndpoint,
    required this.touchpoint,
    this.deviceToken,
    this.deviceType,
  }) {
    _wsEndpoint = 'wss://${host}v1/ws/{visitorToken}';
    _uploadEndpoint = 'https://${host}v1/upload';
    _connectionStateSubject = BehaviorSubject.seeded(LiveTexConnectionState.NOT_STARTED);
    _apiManager = ApiManager(
      Dio(BaseOptions(followRedirects: false, contentType: "application/json"))
        ..interceptors.add(
          LogInterceptor(),
        ),
    );
    _websocketListener = LiveTexFlutter.instance.socketListener;
  }

  static NetworkManager get instance => _instance!;

  static void init(String host, String authEndpoint, String touchpoint, String? deviceToken) {
    _instance = NetworkManager._(
      authEndpoint: authEndpoint,
      touchpoint: touchpoint,
      deviceToken: deviceToken,
      deviceType: Platform.operatingSystem,
      host: host,
    );
  }

  Future<String> connect(AuthData authData, bool reconnectRequired) async {
    this.authData = authData;
    try {
      _lastVisitorToken =
          await _auth(touchpoint, authData.visitorToken, deviceToken, deviceType, authData.customVisitorToken);
    } catch (e) {
      rethrow;
    }
    _onVisitorTokenUpdated();
    _connectWebSocket();
    return _lastVisitorToken!;
  }

  Future<String> _auth(String touchpoint, String? visitorToken, String? deviceToken, String? deviceType,
      String? customVisitorToken) async {
    final queryParameters = {
      'touchPoint': touchpoint,
      if (visitorToken != null) 'visitorToken': visitorToken,
      if (customVisitorToken != null) 'customVisitorToken': customVisitorToken,
      if (deviceToken != null) 'deviceToken': deviceToken,
      if (deviceType != null) 'deviceType': deviceType,
    };
    final response = await _apiManager.dio.get(authEndpoint, queryParameters: queryParameters);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.data.toString());
      var responseEntity = AuthResponseEntity.fromJson(data ?? {});
      if (responseEntity.endpoints.ws.isNotEmpty) {
        _wsEndpoint = responseEntity.endpoints.ws;
      }
      if (responseEntity.endpoints.upload.isNotEmpty) {
        _uploadEndpoint = responseEntity.endpoints.upload;
      }
      return responseEntity.visitorToken;
    } else {
      throw Exception('Failed to authenticate');
    }
  }

  void _connectWebSocket() {
    if (_lastVisitorToken == null) {
      debugPrint('Connect: visitor token is null');
      _connectionStateSubject.add(LiveTexConnectionState.DISCONNECTED);
    } else if (_webSocket != null) {
      debugPrint('Connect: websocket is active!');
    } else {
      String url = _wsEndpoint!.replaceFirst('{visitorToken}', _lastVisitorToken!);
      _webSocket = WebSocketChannel.connect(Uri.parse(url));
      _websocketListener.onOpen(_webSocket!);
      _webSocket!.stream.listen((event) {
        _websocketListener.onMessage(_webSocket!, event);
      });
    }
  }

  void forceDisconnect() {
    authData = null;
    if (_webSocket != null) {
      debugPrint('Disconnecting websocket...');
      _webSocket!.sink.close(1000, 'disconnect requested');
      _websocketListener.onClosed(_webSocket!);
      if (_connectionStateSubject.value != LiveTexConnectionState.DISCONNECTED) {
        _connectionStateSubject.add(LiveTexConnectionState.DISCONNECTED);
      }
    } else {
      debugPrint('Websocket disconnect requested but websocket is null');
    }
  }

  void _onVisitorTokenUpdated() {
    if (_lastVisitorToken != null) {
      _apiManager.setAuthToken(_lastVisitorToken!);
    }
  }

  ApiManager get apiManager => _apiManager;

  WebSocketChannel? get webSocket => _webSocket;

  String get uploadEndpoint => _uploadEndpoint ?? '';

  BehaviorSubject<LiveTexConnectionState> get connectionStateSubject => _connectionStateSubject;
}
