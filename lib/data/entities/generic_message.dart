import 'package:livetex_flutter/data/entities/creator.dart';

abstract class GenericMessage {
  DateTime? get createdTime;

  Creator getCreator();

  void setCreator(Creator creator);
}
