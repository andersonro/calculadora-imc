import 'package:sqflite/sqflite.dart';

class DB {
  // Constrrutor privado
  DB._();

  // Criar instancia do banco de dados
  static final DB instance = DB._();

  //Instancia do SQLite
  static Database? _database;

  get database async {
    if (_database != null) return _database;
    _database = await _initDB();
    return _database;
  }

  _initDB() async {
    return await openDatabase('db_imc', version: 1, onCreate: _onCreate);
  }

  _onCreate(Database db, int version) async {
    await db.execute(_usuario);
    await db.execute(_imc);
    db.close();
  }

  String get _usuario => '''
      CREATE TABLE usuario(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT,
        altura REAL
      )
    ''';

  String get _imc => '''
      CREATE TABLE imc(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        id_usuario INTEGER,
        peso REAL,
        data TEXT,
        imc TEXT,
        FOREIGN KEY(id_usuario) REFERENCES usuario(id)
      )
    ''';
}
