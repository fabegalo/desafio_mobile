import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Model {
  late String databaseName;
  late int databaseVersion;
  late String table;

  static final columnId = '_id';

  List<ColumnModel> columns = [];

  setDatabaseName(String value) {
    this.databaseName = value;
  }

  setDatabaseVersion(int value) {
    this.databaseVersion = value;
  }

  setTable(String value) {
    this.table = value;
  }

  setColumn(List<ColumnModel> value) {
    this.columns = value;
  }

  // tem somente uma referência ao banco de dados
  static late Database _database;

  Future<Database> get database async {
    //if (_database.) return _database;
    // instancia o db na primeira vez que for acessado
    _database = await initDatabase();
    return _database;
  }

  // abre o banco de dados e o cria se ele não existir
  initDatabase() async {
    String documentsDirectory = await getDatabasesPath();
    String path = join(documentsDirectory, databaseName);
    return await openDatabase(path,
        version: databaseVersion, onCreate: onCreate);
  }

  // // Código SQL para criar o banco de dados e a tabela
  // Future onCreate(Database db, int version) async {
  //   await db.execute(
  //       "CREATE TABLE $table ($columnId INTEGER PRIMARY KEY, $columnIdLinha INTEGER NOT NULL, $columnProduto TEXT NOT NULL, $columnDate TEXT NOT NULL, $columnUsuario TEXT NOT NULL, $columnContagem TEXT NOT NULL, $columnSaldo INT NOT NULL, $columnAlmoxarifado TEXT NOT NULL, $columnOperacao TEXT NOT NULL, $columnEnviado TEXT NOT NULL, $columnFilial TEXT NOT NULL, $columnIdarea INT NOT NULL, $columnHora TEXT NOT NULL)");
  // }

  // Código SQL para criar o banco de dados e a tabela
  Future onCreate(Database db, int version) async {
    print('Entrei no onCreate');
    var sql = "CREATE TABLE $table ($columnId INTEGER PRIMARY KEY,";

    var last = columns.length;
    var count = 0;

    for (ColumnModel column in columns) {
      count++;
      if (count == last) {
        sql += column.name + ' ' + column.type + ')';
      } else {
        sql += column.name + ' ' + column.type + ',';
      }
    }

    print('---SQL WHERE---');
    print(sql);

    await db.execute(sql);
  }

  Future createTableForce() async {
    Database db = await initDatabase();

    print('Entrei no onCreate');
    var sql =
        "CREATE TABLE IF NOT EXISTS $table ($columnId INTEGER PRIMARY KEY,";

    var last = columns.length;
    var count = 0;

    for (ColumnModel column in columns) {
      count++;
      if (count == last) {
        sql += column.name + ' ' + column.type + ')';
      } else {
        sql += column.name + ' ' + column.type + ',';
      }
    }

    print('---SQL WHERE---');
    print(sql);

    await db.execute(sql);
  }

  // métodos Helper
  //----------------------------------------------------
  // Insere uma linha no banco de dados onde cada chave
  // no Map é um nome de coluna e o valor é o valor da coluna.
  // O valor de retorno é o id da linha inserida.
  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await database;
    return await db.insert(table, row);
  }

  // Todas as linhas são retornadas como uma lista de mapas, onde cada mapa é
  // uma lista de valores-chave de colunas.
  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await database;
    return await db.query(table);
  }

  // Todos os métodos : inserir, consultar, atualizar e excluir,
  // também podem ser feitos usando  comandos SQL brutos.
  // Esse método usa uma consulta bruta para fornecer a contagem de linhas.
  Future<int?> queryRowCount() async {
    Database db = await database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $table'));
  }

  Future<List<Map<String, dynamic>>> select($sql) async {
    Database db = await database;
    return await db.rawQuery($sql);
  }

  // Assumimos aqui que a coluna id no mapa está definida. Os outros
  // valores das colunas serão usados para atualizar a linha.
  Future<int> update(Map<String, dynamic> row) async {
    Database db = await database;
    int id = row[columnId];
    return await db.update(table, row, where: '$columnId = ?', whereArgs: [id]);
  }

  // Exclui a linha especificada pelo id. O número de linhas afetadas é
  // retornada. Isso deve ser igual a 1, contanto que a linha exista.
  Future<int> delete(int id) async {
    Database db = await database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }
}

class ColumnModel {
  String name;
  String type;

  ColumnModel(this.name, this.type);
}
