import 'package:clean_flutter_app/domain/entities/account_entity.dart';

class RemoteAccountModel {
  final String accessToken;

  RemoteAccountModel(this.accessToken);

  factory RemoteAccountModel.fromJSON(Map json) =>
      RemoteAccountModel(json['accessToken']);

  AccountEntity toEntity() => AccountEntity(accessToken);
}
