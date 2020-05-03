import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qrreader/src/models/scan_model.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  static Database _database;
  static final DBProvider db = DBProvider._();

  DBProvider._();

  Future<Database>get database async {
    if (_database != null) return database;
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'ScansDB.db');
    return await openDatabase(
      path, 
      version: 1,
      onOpen: (db) {},
      onCreate: (Database db, int version) async {
        await db.execute(
          'CREATE TABLE Scans ('
          ' id INTEGER PRIMARY KEY,'
          ' type TEXT,'
          ' value TEXT'
          ')'
        );
      }
    );
  }

  newScanRow(Scan newScan) async {
    final db = await database;
    final res = await db.rawInsert(
      "INSERT Into Scans (id, type, value) "
      "VALUES (${newScan.id}, '${newScan.type}', '${newScan.value}')"
    );
    return res;
  }

  newScan(Scan newScan) async {
    final db = await database;
    final res = await db.insert('Scans', newScan.toJson());
    return res;
  }

  Future<List<Scan>> getScans() async {
    final db = await database;
    final res = await db.query('Scans');
    List<Scan> list = res.isNotEmpty ? res.map((scan) => Scan.fromJson(scan)).toList() : [];
    return list;
  }

  Future<Scan> getScanById(int id) async {
    final db = await database;
    final res = await db.query('Scans', where: 'id = ?', whereArgs: [id]);
    return res.isNotEmpty ? Scan.fromJson(res.first) : null;
  }

  Future<List<Scan>> getScansByType(String type) async {
    final db = await database;
    final res = await db.query('Scans', where: 'type = ?', whereArgs: [type]);
    List<Scan> list = res.isNotEmpty ? res.map((scan) => Scan.fromJson(scan)).toList() : [];
    return list;
  }

  Future<int> updateScan(Scan newScan) async {
    final db = await database;
    final res = await db.update('Scans', newScan.toJson(), where: 'id = ?', whereArgs: [newScan.id]);
    return res;
  }
}