import 'package:flutter/material.dart';
import '../models/health_record.dart';
import '../db/db_helper.dart';

class RecordProvider extends ChangeNotifier {
  List<HealthRecord> _records = [];

  List<HealthRecord> get records => _records;

  Future loadRecords() async {
    _records = await DBHelper.instance.getRecords();
    notifyListeners();
  }

  Future addRecord(HealthRecord record) async {
    await DBHelper.instance.insertRecord(record);
    await loadRecords();
  }

  Future updateRecord(HealthRecord record) async {
    await DBHelper.instance.updateRecord(record);
    await loadRecords();
  }

  Future deleteRecord(int id) async {
    await DBHelper.instance.deleteRecord(id);
    await loadRecords();
  }
}
