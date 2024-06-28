import 'package:equatable/equatable.dart';

class AccountEntity extends Equatable {
  final String token;

  const AccountEntity(this.token);

  factory AccountEntity.fromJSON(Map json) => AccountEntity(json['accessToken']);
  
  @override
  List<Object?> get props => [token];
}
