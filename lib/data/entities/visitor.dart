import 'package:livetex_flutter/data/entities/creator.dart';

class Visitor implements Creator {
  static const String TYPE = "visitor";

  Visitor();

  factory Visitor.fromJson(Map<String, dynamic> json) {
    // Implement fromJson if needed
    return Visitor();
  }

  Map<String, dynamic> toJson() {
    return {
      'type': TYPE,
    };
  }
}
