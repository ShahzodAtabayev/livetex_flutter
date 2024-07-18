import 'package:flutter/material.dart';

class ChatRateWidget extends StatelessWidget {
  final bool isEmployeeEstimated;
  final ValueChanged<bool> onTap;

  const ChatRateWidget({
    super.key,
    required this.isEmployeeEstimated,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (isEmployeeEstimated) {
      return const SizedBox.shrink();
    } else {
      return Container(
        height: 48,
        decoration: const BoxDecoration(color: Color(0xFFF3F3F3)),
        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 16),
        child: Row(
          children: [
            const Expanded(
              child: Text(
                'Оцените качество обслуживания',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12, color: Colors.black),
              ),
            ),
            GestureDetector(
              onTap: () => onTap.call(true),
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                padding: const EdgeInsets.all(8),
                child: const Icon(Icons.gpp_good_rounded),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () => onTap.call(false),
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                padding: const EdgeInsets.all(8),
                child: const Icon(Icons.gpp_bad),
              ),
            ),
          ],
        ),
      );
    }
  }
}
