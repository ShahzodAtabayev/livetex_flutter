import 'package:intl/intl.dart';
import 'package:livetex_flutter/data/entities/file_message.dart';
import 'package:livetex_flutter/data/entities/generic_message.dart';
import 'package:flutter/material.dart';
import 'package:livetex_flutter/data/entities/text_message.dart';
import 'package:livetex_flutter/data/entities/visitor.dart';

class MessageItem extends StatelessWidget {
  final VoidCallback onTap;
  final GenericMessage genericMessage;
  final bool showDate;

  const MessageItem({
    super.key,
    required this.genericMessage,
    required this.showDate,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const radius = Radius.circular(10);
    const languageCode = 'ru';
    final size = MediaQuery.of(context).size;
    if (genericMessage is TextMessage) {
      final message = genericMessage as TextMessage;
      final isMe = genericMessage.getCreator() is Visitor;
      final formatter = DateFormat.MMMMd(languageCode);
      final messageDate = message.createdAt?.toLocal();
      final borderRadius = BorderRadius.only(
        topLeft: radius,
        topRight: radius,
        bottomLeft: isMe ? radius : Radius.zero,
        bottomRight: isMe ? Radius.zero : radius,
      );
      return GestureDetector(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            if (messageDate != null && showDate)
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFDAE0E6),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  margin: const EdgeInsets.only(bottom: 20),
                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  child: Text(
                    '${formatter.format(messageDate)}${messageDate.year != DateTime.now().year ? ' ${messageDate.year}' : ''}',
                    style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
                  ),
                ),
              ),
            Container(
              decoration: BoxDecoration(
                borderRadius: borderRadius,
                color: isMe ? const Color(0xFFFFD600) : const Color(0xFFDAE0E6),
              ),
              constraints: BoxConstraints(maxWidth: size.width * 0.6),
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 12,
                      left: 12,
                      right: 20,
                      bottom: 16,
                    ),
                    child: Text(message.content,
                        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12, color: Color(0xFF333333))),
                  ),
                  if (messageDate != null)
                    Positioned(
                      right: 8,
                      bottom: 4,
                      child: Text(
                        DateFormat("HH:mm").format(messageDate),
                        style: const TextStyle(fontSize: 8, color: Colors.black, fontWeight: FontWeight.w500),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      );
    } else if (genericMessage is FileMessage) {
      final message = genericMessage as FileMessage;
      final isMe = genericMessage.getCreator() is Visitor;
      final formatter = DateFormat.MMMMd(languageCode);
      final messageDate = message.createdAt?.toLocal();
      final borderRadius = BorderRadius.only(
        topLeft: radius,
        topRight: radius,
        bottomLeft: isMe ? radius : Radius.zero,
        bottomRight: isMe ? Radius.zero : radius,
      );
      return GestureDetector(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            if (messageDate != null && showDate)
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFDAE0E6),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  margin: const EdgeInsets.only(bottom: 20),
                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  child: Text(
                    '${formatter.format(messageDate)}${messageDate.year != DateTime.now().year ? ' ${messageDate.year}' : ''}',
                    style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
                  ),
                ),
              ),
            Container(
              decoration: BoxDecoration(
                borderRadius: borderRadius,
                color: isMe ? const Color(0xFFFFD600) : const Color(0xFFDAE0E6),
              ),
              constraints: BoxConstraints(maxWidth: size.width * 0.6),
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 12,
                      left: 12,
                      right: 20,
                      bottom: 16,
                    ),
                    child: Image.network(
                      message.url,
                      fit: BoxFit.cover,
                      width: size.width * 0.6,
                      height: size.width * 0.6,
                    ),
                  ),
                  if (messageDate != null)
                    Positioned(
                      right: 8,
                      bottom: 4,
                      child: Text(
                        DateFormat("HH:mm").format(messageDate),
                        style: const TextStyle(fontSize: 8, color: Colors.black, fontWeight: FontWeight.w500),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
