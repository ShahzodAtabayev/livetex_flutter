import 'package:livetex_flutter/core/enums/livetex_connection_state.dart';
import 'package:livetex_flutter_example/widgets/chat_rate_widget.dart';
import 'package:livetex_flutter/data/entities/generic_message.dart';
import 'package:livetex_flutter_example/widgets/footer_layout.dart';
import 'package:livetex_flutter_example/widgets/message_item.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:livetex_flutter_example/widgets/footer.dart';
import 'package:livetex_flutter/data/models/auth_data.dart';
import 'package:livetex_flutter/core/network_manager.dart';
import 'package:livetex_flutter/livetex_flutter.dart';
import 'package:livetex_flutter_example/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';

import 'package:lottie/lottie.dart';

void main() {
  Intl.systemLocale = 'ru';
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: const Locale('ru'),
      supportedLocales: const [Locale('ru')],
      localizationsDelegates: const [
        GlobalWidgetsLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: Builder(builder: (context) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Live Tex Example'),
          ),
          floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.chat),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ChatExamplePage(),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}

class ChatExamplePage extends StatefulWidget {
  const ChatExamplePage({super.key});

  @override
  State<ChatExamplePage> createState() => _ChatExamplePageState();
}

class _ChatExamplePageState extends State<ChatExamplePage> {
  LiveTexConnectionState _connectionState = LiveTexConnectionState.NOT_STARTED;
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final List<GenericMessage> _msList = [];
  Timer? _typingCancelTimer;

  bool _isShowInput = false;
  bool _isContentLoading = true;
  bool _isEmployeeEstimated = true;
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    initLiveTex();
  }

  Future<void> initLiveTex() async {
    LiveTexBuilder(touchpoint: "your touch point")
      ..setDeviceToken("deviceToken1234")
      ..enableWebsocketLogging()
      ..build();
    final data = AuthData.withVisitorToken(visitorToken: "4e5fac0a-c9d7-4a56-88b1-e2e9b66fe53d");
    try {
      NetworkManager.instance.connect(data, true).then((token) {});
    } catch (_) {}
    LiveTexFlutter.instance.messagesHandler.departmentRequest().listen((event) {});
    LiveTexFlutter.instance.messagesHandler.attributesRequest().listen((event) {
      LiveTexFlutter.instance.messagesHandler.sendAttributes(
        phone: "+998901234567",
        email: "email@mail.com",
        name: "Shahzod's Live Tex plugin",
      );
    });
    LiveTexFlutter.instance.messagesHandler.historyUpdate().listen((event) {
      _msList.addAll(event.messages);
      if (mounted) {
        setState(() {
          _isContentLoading = false;
        });
      }
    });

    LiveTexFlutter.instance.messagesHandler.dialogStateUpdate().listen((event) {
      if (mounted) {
        setState(() {
          _isEmployeeEstimated = !(event.employee != null && event.employee!.rating == null);
        });
      }
    });
    LiveTexFlutter.instance.messagesHandler.employeeTyping().listen((event) {
      _typingCancelTimer?.cancel();
      if (mounted) {
        setState(() => _isTyping = true);
      }
      _typingCancelTimer = Timer(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() => _isTyping = false);
        }
      });
    });

    NetworkManager.instance.connectionStateSubject.stream.listen((event) {
      if (mounted) {
        setState(() {
          _connectionState = event;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Tex Example'),
        actions: [
          _connectionState == LiveTexConnectionState.CONNECTING
              ? const SizedBox(
                  height: 16,
                  width: 16,
                  child: CircularProgressIndicator(strokeWidth: 2.2, color: Colors.blue),
                )
              : const SizedBox.shrink()
        ],
      ),
      body: _isContentLoading
          ? const Center(
              child: SizedBox(
                height: 36,
                width: 36,
                child: CircularProgressIndicator(strokeWidth: 3.4, color: Colors.blue),
              ),
            )
          : FooterLayout(
              footer: _msList.isNotEmpty || _isShowInput
                  ? FooterWidget(focusNode: _focusNode, textEditingController: _textEditingController)
                  : SafeArea(
                      bottom: true,
                      minimum: const EdgeInsets.only(bottom: 20, left: 16, right: 16),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _isShowInput = true;
                          });
                          _focusNode.requestFocus();
                        },
                        child: Container(
                          height: 52,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Center(
                            child: Text(
                              "Write message",
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                      ),
                    ),
              child: Builder(
                builder: (context) {
                  final reversedList = _msList.reversed;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ChatRateWidget(
                        isEmployeeEstimated: _isEmployeeEstimated,
                        onTap: (isPositiveFeedback) {
                          LiveTexFlutter.instance.messagesHandler.sendRatingEvent(isPositiveFeedback);
                        },
                      ),
                      Expanded(
                        child: ListView.separated(
                          reverse: true,
                          itemCount: reversedList.length,
                          padding: const EdgeInsets.all(16),
                          separatorBuilder: (_, index) => const SizedBox(height: 8),
                          itemBuilder: (_, index) {
                            final message = reversedList.elementAt(index);
                            final previousMessage =
                                index < reversedList.length - 1 ? reversedList.elementAt(index + 1) : null;
                            final messageDate = message.createdTime?.toLocal() ?? DateTime.now();
                            final previousMessageDate = previousMessage?.createdTime?.toLocal() ?? DateTime.now();
                            return MessageItem(
                              genericMessage: message,
                              onTap: () {
                                // if (message.content?.file != null) {
                                //   context.push(
                                //     Routes.chatMessageImage,
                                //     extra: ChatMessageImagePageArguments(url: message.content?.file?.url),
                                //   );
                                // }
                              },
                              showDate:
                                  index == reversedList.length - 1 || !messageDate.isSameDate(previousMessageDate),
                            );
                          },
                        ),
                      ),
                      if (_isTyping)
                        Container(
                          width: 70,
                          height: 36,
                          margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                            ),
                            color: Color(0xFF474747),
                          ),
                          child: LottieBuilder.asset(
                            'assets/chat_typing_indicator.json',
                            height: 36,
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
    );
  }

  @override
  void dispose() {
    LiveTexFlutter.reset();
    super.dispose();
  }
}
