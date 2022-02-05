import 'package:sqflite/sqflite.dart';

class DBHelper {
  static Database? _db;

  static const String QUERY_TBL_PELANGGAN = """
CREATE TABLE pelanggan (
  id INTEGER PRIMARY KEY,
  nama TEXT,
  gender TEXT,
  tgl_lahir TEXT
)
""";

  static Future<Database?> db() async {
    return _db ??= (await DBHelper().connectDB());
  }

  Future<Database> connectDB() async {
    return await openDatabase('mydata.db', version: 1, onCreate: (db, version) {
      db.execute(QUERY_TBL_PELANGGAN);
    });
  }
}
