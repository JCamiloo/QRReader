import 'dart:async';

import 'package:qrreader/src/models/scan_model.dart';
import 'package:qrreader/src/providers/db_provider.dart';

class ScansBloc {
  
  static final ScansBloc _singleton = new ScansBloc._();

  factory ScansBloc() {
    return _singleton;
  }

  ScansBloc._() {
    getScans();
  }

  final _scansStreamController = StreamController<List<Scan>>.broadcast();

  Stream<List<Scan>> get scansStream => _scansStreamController.stream;

  getScans() async {
    _scansStreamController.sink.add(await DBProvider.db.getScans());
  }

  addScan(Scan scan) async {
    await DBProvider.db.newScan(scan);
    getScans();
  }

  deleteScan(int id) async {
    await DBProvider.db.deleteScan(id);
    getScans();
  }

  deleteAllScans() async {
    await DBProvider.db.deleteAll();
    getScans();
  }

  dispose() {
    _scansStreamController?.close();
  }
}