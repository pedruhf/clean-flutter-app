class AccountEntity {
  final String token;

  AccountEntity(this.token);

  factory AccountEntity.fromJSON(Map json) => AccountEntity(json['accessToken']);
}
