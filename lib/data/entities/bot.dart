import 'package:livetex_flutter/data/entities/creator.dart';

class Bot implements Creator {
  static const String TYPE = "bot";

  Bot();

  factory Bot.fromJson(Map<String, dynamic> json) {
    // Implement fromJson if needed
    return Bot();
  }

  Map<String, dynamic> toJson() {
    return {
      'type': TYPE,
    };
  }
}
