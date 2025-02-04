import 'package:livetex_flutter/core/livetex_message_handler.dart';
import 'package:livetex_flutter/core/livetex_websocket_listener.dart';
import 'package:livetex_flutter/core/network_manager.dart';

class LiveTexFlutter {
  static LiveTexFlutter? _instance;

  late final LiveTexWebSocketListener _socketListener;

  late final LiveTexMessagesHandler _messagesHandler;

  LiveTexFlutter._(LiveTexBuilder builder) {
    _instance = this;
    _socketListener = builder.socketListener;
    _messagesHandler = builder.messagesHandler;
  }

  static LiveTexFlutter get instance {
    if (_instance == null) {
      throw StateError(
          "LiveTex instance method called too early. Create LiveTex instance with LiveTexBuilder()");
    }
    return _instance!;
  }

  static void init(LiveTexBuilder builder) {
    if (_instance != null) {
      throw StateError(
          "LiveTex instance already exists. Use the existing instance or reset it before initializing again.");
    }
    _instance = LiveTexFlutter._(builder);
  }

  static void reset() {
    _instance = null;
    NetworkManager.instance.forceDisconnect();
  }

  NetworkManager get networkManager => NetworkManager.instance;

  LiveTexMessagesHandler get messagesHandler => _messagesHandler;

  LiveTexWebSocketListener get socketListener => _socketListener;
}

class LiveTexBuilder {
  String host;
  String authEndpoint;
  final String touchpoint;
  String? deviceToken;
  bool isNetworkLoggingEnabled;
  bool isWebsocketLoggingEnabled;
  LiveTexMessagesHandler? _messagesHandler;

  LiveTexWebSocketListener? _socketListener;

  LiveTexBuilder({
    required this.touchpoint,
    this.host = 'visitor-api.livetex.ru/',
    this.authEndpoint = 'https://visitor-api.livetex.ru/v1/auth',
    this.deviceToken,
    this.isNetworkLoggingEnabled = false,
    this.isWebsocketLoggingEnabled = false,
  });

  LiveTexBuilder setHost(String host) {
    this.host = host;
    return this;
  }

  LiveTexBuilder setAuthEndpoint(String authEndpoint) {
    this.authEndpoint = authEndpoint;
    return this;
  }

  LiveTexBuilder setDeviceToken(String? deviceToken) {
    this.deviceToken = deviceToken;
    return this;
  }

  LiveTexBuilder enableNetworkLogging() {
    isNetworkLoggingEnabled = true;
    return this;
  }

  LiveTexBuilder enableWebsocketLogging() {
    isWebsocketLoggingEnabled = true;
    return this;
  }

  set socketListener(LiveTexWebSocketListener value) {
    _socketListener = value;
  }

  set messagesHandler(LiveTexMessagesHandler value) {
    _messagesHandler = value;
  }

  void build() {
    LiveTexFlutter.init(this);
    NetworkManager.init(host, authEndpoint, touchpoint, deviceToken);
    messagesHandler.init(isWebsocketLoggingEnabled);
    socketListener.init();
  }

  LiveTexMessagesHandler get messagesHandler =>
      _messagesHandler ??= LiveTexMessagesHandler();

  LiveTexWebSocketListener get socketListener =>
      _socketListener ??= LiveTexWebSocketListener();
}
