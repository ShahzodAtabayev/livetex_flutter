import 'package:livetex_flutter/data/entities/department_request_entity.dart';
import 'package:livetex_flutter/data/entities/employee_typing_event.dart';
import 'package:livetex_flutter/data/entities/button_pressed_event.dart';
import 'package:livetex_flutter/core/enums/livetex_connection_state.dart';
import 'package:livetex_flutter/data/models/file_uploaded_response.dart';
import 'package:livetex_flutter/data/models/get_history_request.dart';
import 'package:livetex_flutter/data/entities/attributes_request.dart';
import 'package:livetex_flutter/data/entities/attributes_entity.dart';
import 'package:livetex_flutter/data/entities/response_entity.dart';
import 'package:livetex_flutter/data/entities/history_entity.dart';
import 'package:livetex_flutter/data/entities/dialog_state.dart';
import 'package:livetex_flutter/data/entities/file_message.dart';
import 'package:livetex_flutter/data/entities/rating_event.dart';
import 'package:livetex_flutter/data/entities/text_message.dart';
import 'package:livetex_flutter/data/entities/typing_event.dart';
import 'package:livetex_flutter/data/entities/base_entity.dart';
import 'package:livetex_flutter/data/entities/department.dart';
import 'package:livetex_flutter/data/entities/employee.dart';
import 'package:livetex_flutter/core/network_manager.dart';
import 'package:livetex_flutter/data/entity_mapper.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:convert';

class LiveTexMessagesHandler {
  final String tag = "MessagesHandler";
  bool isWebsocketLoggingEnabled = false;

  final BehaviorSubject<BaseEntity> entitySubject = BehaviorSubject<BaseEntity>();
  final BehaviorSubject<DialogState> dialogStateSubject = BehaviorSubject<DialogState>();
  final BehaviorSubject<HistoryEntity> historyUpdateSubject = BehaviorSubject<HistoryEntity>();
  final BehaviorSubject<EmployeeTypingEvent> employeeTypingSubject = BehaviorSubject<EmployeeTypingEvent>();
  final BehaviorSubject<AttributesRequest> attributesRequestSubject = BehaviorSubject<AttributesRequest>();
  final BehaviorSubject<DepartmentRequestEntity> departmentRequestSubject = BehaviorSubject<DepartmentRequestEntity>();

  Map<String, BehaviorSubject<ResponseEntity>> subscriptions = {};
  Pair<String, BehaviorSubject<int>>? getHistorySubscription;
  EntityMapper mapper = EntityMapper();

  void init(bool isWebsocketLoggingEnabled) {
    this.isWebsocketLoggingEnabled = isWebsocketLoggingEnabled;
    NetworkManager.instance.connectionStateSubject.listen((state) {
      if (state == LiveTexConnectionState.DISCONNECTED) {
        if (isWebsocketLoggingEnabled) {
          debugPrint("[$tag] Disconnect detected, clearing subscriptions");
        }

        for (var subscription in subscriptions.values) {
          if (!subscription.isClosed) {
            subscription.addError(StateError("WebSocket disconnect"));
          }
        }

        subscriptions.clear();
        if (getHistorySubscription != null) {
          getHistorySubscription!.second.addError(StateError("WebSocket disconnect"));
          getHistorySubscription = null;
        }
      }
    }, onError: (thr) {
      debugPrint("[$tag] connectionState observe error: $thr");
    });
  }

  void onMessage(String text) {
    if (isWebsocketLoggingEnabled) {
      debugPrint("[$tag] onMessage $text");
    }

    BaseEntity? entity;
    try {
      entity = mapper.toEntity(text);
    } catch (e) {
      debugPrint("[$tag] Error when parsing message: $e");
    }

    if (entity != null) {
      entitySubject.add(entity);
      if (entity is DialogState) {
        dialogStateSubject.add(entity);
      } else if (entity is HistoryEntity) {
        historyUpdateSubject.add(entity);
        if (getHistorySubscription != null && entity.correlationId == getHistorySubscription!.first) {
          getHistorySubscription!.second.add(entity.messages.length);
          getHistorySubscription = null;
        }
      } else if (entity is EmployeeTypingEvent) {
        employeeTypingSubject.add(entity);
      } else if (entity is AttributesRequest) {
        attributesRequestSubject.add(entity);
      } else if (entity is DepartmentRequestEntity) {
        departmentRequestSubject.add(entity..departments.sort());
      }

      final subscription = subscriptions[entity.correlationId];
      if (subscription != null && entity is ResponseEntity) {
        if (!subscription.isClosed) {
          subscription.add(entity);
        }
        subscriptions.remove(entity.correlationId);
      }
    }
  }

  void setMapper(EntityMapper mapper) {
    this.mapper = mapper;
  }

  Future<int> getHistory(String messageId, {int count = 20}) async {
    final event = GetHistoryRequest(messageId: messageId, offset: count);
    final json = jsonEncode(event);
    if (NetworkManager.instance.webSocket != null) {
      getHistorySubscription = Pair(event.correlationId, BehaviorSubject<int>());
      sendJson(json);
      return getHistorySubscription!.second.first;
    } else {
      throw StateError("Trying to send data when WebSocket is null");
    }
  }

  void sendTypingEvent(String text) {
    final event = TypingEvent(content: text);
    final json = jsonEncode(event);
    sendJson(json);
  }

  void sendAttributes({String? name, String? phone, String? email, Map<String, dynamic>? attrs}) {
    final event = AttributesEntity(name: name, phone: phone, email: email, attrs: attrs);
    final json = jsonEncode(event);
    sendJson(json);
  }

  void sendRatingEvent(bool isPositiveFeedback) {
    final event = RatingEvent(value: isPositiveFeedback ? "1" : "0");
    final json = jsonEncode(event);
    sendJson(json);
  }

  void sendButtonPressedEvent(String payload) {
    final event = ButtonPressedEvent(payload: payload);
    final json = jsonEncode(event);
    sendJson(json);
  }

  Future<ResponseEntity> sendTextMessage(String text) {
    final event = TextMessage(content: text, id: '', createdAt: DateTime.now(), creator: Employee(name: ''));
    final json = jsonEncode(event.toMap());
    return sendAndSubscribe(json, event.correlationId);
  }

  Future<ResponseEntity> sendFileMessage(FileUploadedResponse response) {
    final event = FileMessage.fromResponse(response);
    final json = jsonEncode(event.toJson());
    return sendAndSubscribe(json, event.correlationId);
  }

  Future<ResponseEntity> sendDepartmentSelectionEvent(String departmentId) {
    final event = Department(id: departmentId, name: null, order: null);
    final json = jsonEncode(event.toJson());
    return sendAndSubscribe(json, event.correlationId);
  }

  Stream<BaseEntity> entity() {
    return entitySubject.stream;
  }

  Stream<DialogState> dialogStateUpdate() {
    return dialogStateSubject.stream;
  }

  Stream<HistoryEntity> historyUpdate() {
    return historyUpdateSubject.stream;
  }

  Stream<EmployeeTypingEvent> employeeTyping() {
    return employeeTypingSubject.stream;
  }

  Stream<AttributesRequest> attributesRequest() {
    return attributesRequestSubject.stream;
  }

  Stream<DepartmentRequestEntity> departmentRequest() {
    return departmentRequestSubject.stream;
  }

  Future<ResponseEntity> sendAndSubscribe(String json, String correlationId) async {
    final subscription = BehaviorSubject<ResponseEntity>();
    if (NetworkManager.instance.webSocket != null) {
      subscriptions[correlationId] = subscription;
      sendJson(json);
      return subscription.first;
    } else {
      throw StateError("Trying to send data when WebSocket is null");
    }
  }

  void sendJson(String json) {
    final webSocket = NetworkManager.instance.webSocket;
    if (webSocket != null) {
      if (isWebsocketLoggingEnabled) {
        debugPrint("[$tag] Sending: $json");
      }
      webSocket.sink.add(json);
    } else {
      throw StateError("Trying to send data when WebSocket is null");
    }
  }
}

class Pair<F, S> {
  final F first;
  final S second;

  Pair(this.first, this.second);
}
