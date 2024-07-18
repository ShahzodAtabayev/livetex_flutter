import 'package:livetex_flutter/data/entities/creator.dart';

abstract class GenericMessage {
  String get id;

  DateTime? get createdTime;

  Creator getCreator();

  void setCreator(Creator creator);
}
