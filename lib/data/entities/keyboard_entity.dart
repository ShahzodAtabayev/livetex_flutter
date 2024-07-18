class KeyboardEntity {
  List<Button> buttons;
  bool pressed;

  KeyboardEntity({required this.buttons, this.pressed = false});

  factory KeyboardEntity.fromJson(Map<String, dynamic> json) {
    var buttonsFromJson = json['buttons'] as List;
    List<Button> buttonList = buttonsFromJson.map((i) => Button.fromJson(i)).toList();

    return KeyboardEntity(
      buttons: buttonList,
      pressed: json['pressed'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'buttons': buttons.map((button) => button.toJson()).toList(),
      'pressed': pressed,
    };
  }
}

class Button {
  String label;
  String payload;
  String? url;

  Button({required this.label, required this.payload, this.url});

  factory Button.fromJson(Map<String, dynamic> json) {
    return Button(
      label: json['label'],
      payload: json['payload'],
      url: json['url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'payload': payload,
      'url': url,
    };
  }
}
