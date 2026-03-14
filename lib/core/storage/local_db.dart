import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../data/models/history_entry.dart';

class LocalDb {
  LocalDb._();
  static final LocalDb instance = LocalDb._();

  Database? _db;

  Future<Database> get database async {
    _db ??= await _open();
    return _db!;
  }

  Future<Database> _open() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'hackers.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE history_entries (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            tool_id TEXT NOT NULL,
            tool_name TEXT NOT NULL,
            input TEXT NOT NULL,
            output TEXT NOT NULL,
            timestamp INTEGER NOT NULL
          )
        ''');

        await db.execute('''
          CREATE INDEX idx_tool_id ON history_entries(tool_id)
        ''');
        await db.execute('''
          CREATE INDEX idx_timestamp ON history_entries(timestamp DESC)
        ''');
      },
    );
  }

  Future<int> insertHistory(HistoryEntry entry) async {
    final db = await database;
    final id = await db.insert(
      'history_entries',
      entry.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    // Keep only last 100 entries per tool
    await db.execute('''
      DELETE FROM history_entries
      WHERE tool_id = ? AND id NOT IN (
        SELECT id FROM history_entries
        WHERE tool_id = ?
        ORDER BY timestamp DESC
        LIMIT 50
      )
    ''', [entry.toolId, entry.toolId]);
    return id;
  }

  Future<List<HistoryEntry>> getHistoryForTool(String toolId, {int limit = 20}) async {
    final db = await database;
    final maps = await db.query(
      'history_entries',
      where: 'tool_id = ?',
      whereArgs: [toolId],
      orderBy: 'timestamp DESC',
      limit: limit,
    );
    return maps.map(HistoryEntry.fromMap).toList();
  }

  Future<List<HistoryEntry>> getAllHistory({int limit = 100}) async {
    final db = await database;
    final maps = await db.query(
      'history_entries',
      orderBy: 'timestamp DESC',
      limit: limit,
    );
    return maps.map(HistoryEntry.fromMap).toList();
  }

  Future<void> clearHistoryForTool(String toolId) async {
    final db = await database;
    await db.delete('history_entries', where: 'tool_id = ?', whereArgs: [toolId]);
  }

  Future<void> clearAllHistory() async {
    final db = await database;
    await db.delete('history_entries');
  }

  Future<int> deleteHistory(int id) async {
    final db = await database;
    return db.delete('history_entries', where: 'id = ?', whereArgs: [id]);
  }
}
