import 'package:path/path.dart' show join;
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DbHelper {
  static final _databaseName = "Formku.db";
  static final _databaseVersion = 1;

  static final table = 'Mahasiswa';

  static final columnNIM = 'NIM';
  static final columnName = 'name';
  static final columnTanggal = 'TanggalLahir';
  static final columnJurusan = 'Jurusan';
  static final columnEmail = 'email';
  static final columnImage = 'image';

  DbHelper._privateConstructor();
  static final DbHelper instance = DbHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    // Directory documentsDirectory = await getApplicationDocumentsDirectory();
    var documentsDirectory = await getDatabasesPath();
    String path = join(documentsDirectory, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate, singleInstance: true);
  }

  //buat tabel

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnNIM INTEGER PRIMARY KEY,
            $columnName TEXT,
            $columnTanggal TEXT,
            $columnJurusan TEXT,
            $columnEmail TEXT,
            $columnImage TEXT
          )
          ''');
  }

  //Masukan data
  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(table, row);
  }

  //Baca data
  Future<List<Map<String, dynamic>>> queryAll() async {
    Database db = await instance.database;
    return await db.query(table, orderBy: 'name');
  }

  //update data
  Future<int> update(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[columnNIM];
    return await db
        .update(table, row, where: '$columnNIM = ?', whereArgs: [id]);
  }

  //delete data
  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnNIM = ?', whereArgs: [id]);
  }
}
