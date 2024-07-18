import 'package:livetex_flutter/data/entities/base_entity.dart';
import 'dart:convert';

class EntityMapper {
  BaseEntity toEntity(String jsonStr) {
    Map<String, dynamic> json = jsonDecode(jsonStr);
    return BaseEntity.fromJson(json);
  }
}
