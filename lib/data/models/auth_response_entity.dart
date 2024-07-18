class AuthResponseEntity {
  static const String TYPE = 'attributes';
  final String visitorToken;
  final Endpoints endpoints;

  AuthResponseEntity({
    required this.visitorToken,
    required this.endpoints,
  });

  factory AuthResponseEntity.fromJson(Map<String, dynamic> json) {
    return AuthResponseEntity(
      visitorToken: json['visitorToken'],
      endpoints: Endpoints.fromJson(json['endpoints']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'visitorToken': visitorToken,
      'endpoints': endpoints.toJson(),
    };
  }
}

class Endpoints {
  final String ws;
  final String upload;

  Endpoints({
    required this.ws,
    required this.upload,
  });

  factory Endpoints.fromJson(Map<String, dynamic> json) {
    return Endpoints(
      ws: json['ws'],
      upload: json['upload'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ws': ws,
      'upload': upload,
    };
  }
}
