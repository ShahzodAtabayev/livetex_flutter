import 'package:livetex_flutter/data/entities/creator.dart';

class SystemUser implements Creator {
  static const String TYPE = "system";

  SystemUser();

  factory SystemUser.fromJson(Map<String, dynamic> json) {
    // Implement fromJson if needed
    return SystemUser();
  }

  Map<String, dynamic> toJson() {
    return {
      'type': TYPE,
    };
  }
}
