import 'package:livetex_flutter/data/entities/bot.dart';
import 'package:livetex_flutter/data/entities/employee.dart';
import 'package:livetex_flutter/data/entities/system_user.dart';
import 'package:livetex_flutter/data/entities/visitor.dart';

abstract class Creator {
  factory Creator.fromJson(Map<String, dynamic> json) {
    switch (json['type']) {
      case 'employee':
        final map = json['employee'];
        return Employee.fromJson(map);
      case 'visitor':
        return Visitor();
      case 'system':
        return SystemUser();
      case 'bot':
        return Bot();
      default:
        {
          return UnknownCreator();
        }
    }
  }
}

class UnknownCreator implements Creator {}
