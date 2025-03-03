import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_sqlcipher/sqflite.dart' as d;
import 'package:task_manager/utils/global_functions/global_functions.dart';
import 'package:task_manager/utils/services/version_config.dart';

import '../app_constants/appconstants.dart';

class DatabaseHelper {
  DatabaseHelper._init();
  static final DatabaseHelper instance = DatabaseHelper._init();
  d.Database? myDatabase;
  final _storage = const FlutterSecureStorage();
  static String? _password;
  static const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
  static const varcharType = 'VARCHAR';

  static const notifications = '''
    id $idType,
    title $varcharType NOT NULL,
    body $varcharType NOT NULL,
    data $varcharType NOT NULL,
    timestamp $varcharType NOT NULL
''';

  static const usersTable = '''
    id TEXT PRIMARY KEY,
    email TEXT NOT NULL UNIQUE,
    password TEXT NOT NULL
''';

  static const tasksTable = '''
    id TEXT PRIMARY KEY,
    uniqueId TEXT UNIQUE,
    title TEXT NOT NULL,
    description TEXT NOT NULL,
    start_date TEXT,
    due_date TEXT,
    priority TEXT,
    status TEXT NOT NULL,
    category TEXT NOT NULL,
    isSynced INTEGER NOT NULL DEFAULT 0,
    updated_at TEXT
''';

  static const subtasksTable = '''
  id TEXT PRIMARY KEY,
  uniqueId TEXT NOT NULL,
  title TEXT NOT NULL,
  isCompleted INTEGER NOT NULL DEFAULT 0,
  updated_at TEXT
''';

  // Get the Database.
  Future<d.Database> get database async {
    if (myDatabase != null) return myDatabase!;

    myDatabase = await _initDB('taskManager.db');

    return myDatabase!;
  }

  // Initialize the database.
  Future<d.Database> _initDB(String filepath) async {
    final directory = await getApplicationDocumentsDirectory();

    final path = p.join(directory.path, filepath);
    _password = await _getPassword();

    return d.openDatabase(
      path,
      version: VersionConfig.databaseVersion,
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
      password: _password,
    );
  }

  Future<void> reinitializeDatabase() async {
    // Close the current database if it’s open.
    if (myDatabase != null && myDatabase!.isOpen) {
      await myDatabase!.close();
    }

    // Set myDatabase to null, forcing `get database` to re-run `_initDB`.
    myDatabase = null;

    // Calling this will now recreate the database file and run onCreate if needed.
    await database;
  }

  // Handle database upgrades.
  Future<void> _onUpgrade(d.Database db, int oldVersion, int newVersion) async {
    final batch = db.batch();

    await batch.commit();
  }

  Future<String> _getPassword() async {
    var password = await _storage.read(key: 'db_password');

    if (password == null) {
      password = 'taskx';
      await _storage.write(key: 'db_password', value: password);
    }

    return password;
  }

  // Create tables.
  Future<void> _createDB(d.Database db, int version) async {
    final tables = {
      AppConstants.notificationsTable: notifications,
      AppConstants.usersTable: usersTable,
      AppConstants.tasksTable: tasksTable,
      AppConstants.subtasksTable: subtasksTable,
    };
    for (final table in tables.entries) {
      await db.execute('''
      CREATE TABLE IF NOT EXISTS ${table.key}(${table.value})
    ''');
    }
  }

  // CRUD Operations **/

  // Insert.
  Future<int> insert(String table, Map<String, dynamic> row) async {
    final db = await instance.database;

    if (row['uniqueId'] == null) {
      row['uniqueId'] = GlobalFunctions().generateId();
    }

    return db.insert(
      table,
      row,
      conflictAlgorithm: d.ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> selectAll(
    String table, {
    String? orderByColumn,
    bool ascending = true,
  }) async {
    final db = await instance.database;
    String? orderBy;

    if (orderByColumn != null) {
      orderBy = '$orderByColumn ${ascending ? 'ASC' : 'DESC'}';
    }

    return db.query(
      table,
      orderBy: orderBy,
    );
  }

  Future<List<Map<String, dynamic>>> selectById(
    String table, {
    required String id,
  }) async {
    final db = await instance.database;

    return db.query(
      table,
      where: 'uniqueId = ?',
      whereArgs: [id],
    );
  }

  /// Get all tasks
  Future<List<Map<String, dynamic>>> getAllTasks() async {
    final db = await database;
    return await db.query(AppConstants.tasksTable, orderBy: 'updated_at DESC');
  }

  /// Update a task
  Future<int> updateTask(String id, Map<String, dynamic> taskData) async {
    final db = await database;
    return await db.update(
      AppConstants.tasksTable,
      taskData,
      where: 'uniqueId = ?',
      whereArgs: [id],
    );
  }

  Future<int> update(String table, String id, Map<String, dynamic> data) async {
    final db = await database;
    return await db.update(
      table,
      data,
      where: 'uniqueId = ?',
      whereArgs: [id],
    );
  }

  Future<int> updateTaskStatus(String id, String newStatus) async {
    final db = await database;
    return await db.update(
      AppConstants.tasksTable,
      {
        'status': newStatus,
        'updated_at': DateTime.now().toIso8601String(),
      },
      where: 'uniqueId = ?',
      whereArgs: [id],
    );
  }


  Future<int> updateTaskPriority(String id, String priority) async {
    final db = await database;
    return await db.update(
      AppConstants.tasksTable,
      {
        'priority': priority,
        'updated_at': DateTime.now().toIso8601String(),
      },
      where: 'uniqueId = ?',
      whereArgs: [id],
    );
  }
}
