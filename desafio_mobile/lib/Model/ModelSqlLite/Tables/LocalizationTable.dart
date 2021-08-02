import 'package:desafio_mobile/Model/ModelSqlLite/Model.dart';

class LocalizationTable extends Model {
  LocalizationTable() {
    List<ColumnModel> columns = [
      new ColumnModel('latitude', 'TEXT NOT NULL'),
      new ColumnModel('longitude', 'TEXT NOT NULL'),
      new ColumnModel('datetime', 'TEXT NOT NULL'),
    ];

    setDatabaseName("app_desafio_mobile.db");

    setDatabaseVersion(1);

    setTable("localizations");

    setColumn(columns);

    createTableForce();
  }
}
