import 'package:desafio_mobile/Model/ModelSqlLite/Model.dart';

class LoginTable extends Model {
  LoginTable() {
    List<ColumnModel> columns = [
      new ColumnModel('uid', 'TEXT NOT NULL'),
      new ColumnModel('email', 'TEXT NOT NULL'),
      new ColumnModel('localization_id', 'INTEGER'),
      new ColumnModel('datetime', 'TEXT NOT NULL'),
    ];

    setDatabaseName("app_desafio_mobile.db");

    setDatabaseVersion(1);

    setTable("logins");

    setColumn(columns);

    createTableForce();
  }
}
