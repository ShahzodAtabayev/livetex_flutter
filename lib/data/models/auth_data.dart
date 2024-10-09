/// token : ""
/// device_token : ""
library;

class AuthData {
  AuthData.withVisitorToken({required String visitorToken}) {
    _visitorToken = visitorToken;
  }

  AuthData.withCustomVisitorToken({required String customVisitorToken}) {
    _customVisitorToken = customVisitorToken;
  }

  AuthData.withVisitorAndCustomTokens({
    required String visitorToken,
    required String customVisitorToken,
  }) {
    _customVisitorToken = customVisitorToken;
    _visitorToken = visitorToken;
  }

  String? _visitorToken;
  String? _customVisitorToken;

  String? get visitorToken => _visitorToken;

  String? get customVisitorToken => _customVisitorToken;
}
