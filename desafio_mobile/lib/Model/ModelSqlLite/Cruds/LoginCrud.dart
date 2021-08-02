import 'package:desafio_mobile/Model/Login.dart';
import 'package:desafio_mobile/Model/ModelSqlLite/Tables/LoginTable.dart';

final dbTable = LoginTable();

Future<int> inserir(uid, email, datetime, localizationId) async {
  // linha para incluir
  Map<String, dynamic> row = {
    'uid': uid,
    'email': email,
    'localization_id': localizationId,
    'datetime': datetime
  };

  final id = await dbTable.insert(row);
  print('login inserido id: $id');
  return id;
}

Future<int> updateOrInsert(String? uid, String? email, String? datetime,
    {int? localizationId}) async {
  int id = await verificaSeExisteRegistro(uid);

  if (id != -1) {
    Map<String, dynamic> row = {
      '_id': id,
      'uid': uid,
      'email': email,
      'localization_id': localizationId,
      'datetime': datetime
    };
    atualizar(row);
    return -1;
  } else {
    return await inserir(uid, email, datetime, localizationId);
  }
}

Future<int> verificaSeExisteRegistro(uid) async {
  List<Map<String, dynamic>> retorno =
      await seleciona("SELECT * FROM logins WHERE uid = '$uid'");

  if (retorno.isEmpty) {
    return -1;
  } else {
    return retorno[0]['_id'];
  }
}

void consultar() async {
  final todasLinhas = await dbTable.queryAllRows();
  print('Consulta todos os logins:');
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

Future<List<Login>> getAllLogins() async {
  List<Login> logins = [];

  String $sql = "SELECT * FROM logins";

  var resultado = await dbTable.select($sql);

  for (var row in resultado) {
    logins.add(new Login(
        id: row['id'],
        email: row['email'],
        localizationId: row['localization_id'],
        datetime: row['datetime']));
  }

  return logins;
}
