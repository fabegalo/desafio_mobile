import 'package:desafio_mobile/Model/Localization.dart';
import 'package:desafio_mobile/Model/ModelSqlLite/Tables/LocalizationTable.dart';

final dbTable = LocalizationTable();

Future<int> inserir(latitude, longitude, datetime) async {
  // linha para incluir
  Map<String, dynamic> row = {
    'latitude': latitude,
    'longitude': longitude,
    'datetime': datetime
  };

  final id = await dbTable.insert(row);
  print('localização inserida id: $id');
  return id;
}

Future<int> updateOrInsert(String email, String datetime,
    {int? localizationId}) async {
  int id = await verificaSeExisteRegistro(email);

  if (id != -1) {
    Map<String, dynamic> row = {
      '_id': id,
      'email': email,
      'localization_id': localizationId,
      'datetime': datetime
    };
    atualizar(row);
    return -1;
  } else {
    return await inserir(email, datetime, localizationId);
  }
}

Future<int> verificaSeExisteRegistro(email) async {
  List<Map<String, dynamic>> retorno =
      await seleciona("SELECT * FROM logins WHERE email = '$email'");

  if (retorno.isEmpty) {
    return -1;
  } else {
    return retorno[0]['_id'];
  }
}

void consultar() async {
  final todasLinhas = await dbTable.queryAllRows();
  print('Consulta todos as localizações:');
  todasLinhas.forEach((row) => print(row.toString()));
}

Future<List<Map<String, dynamic>>> seleciona($sql) async {
  final consulta = await dbTable.select($sql);
  // print('Retorno da consulta: ');
  // consulta.forEach((row) => print(row.toString()));
  return consulta;
}

void atualizar(row) async {
  final linhasAfetadas = await dbTable.update(row);
  print('atualizadas $linhasAfetadas linha(s)');
}

void deletar(id) async {
  final linhaDeletada = await dbTable.delete(id);
  print('Deletada(s) $linhaDeletada linha(s): linha $id');
}

Future<int?> getAllRowsCountSQL() async {
  return await dbTable.queryRowCount();
}

Future<List<Localization>> getAllLocalizations() async {
  List<Localization> localizations = [];

  String $sql = "SELECT * FROM localizations";

  var resultado = await dbTable.select($sql);

  for (var row in resultado) {
    localizations.add(new Localization(
        id: row['id'],
        latitude: row['email'],
        longitude: row['localization_id'],
        datetime: row['datetime']));
  }

  return localizations;
}
