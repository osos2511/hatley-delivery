import '../../domain/entities/auth_entity.dart';

class SignInResponse {
  String? token;
  String? expiration;

  SignInResponse({
      this.token, 
      this.expiration,});


  SignInResponse.fromJson(dynamic json) {
    token = json['token'];
    expiration = json['expiration'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['token'] = token;
    map['expiration'] = expiration;
    return map;
  }

  AuthEntity toEntity() {
    return AuthEntity(
      token: token ?? '',
      expiration: expiration ?? '',
    );
  }

}