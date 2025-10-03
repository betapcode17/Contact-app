import "package:contact_app/models/contact.dart";
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ContactDatabaseHelper {
  // Singleton
  static final ContactDatabaseHelper instance = ContactDatabaseHelper._init();
  static Database? _database;

  ContactDatabaseHelper._init();

  // Getter Database
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('app_database.db');
    return _database!;
  }

  // Khởi tạo DB
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  // Tạo bảng
  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE contacts (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        phone TEXT NOT NULL,
        email TEXT NOT NULL,
        avatar TEXT
      )
    ''');

    await _insertSampleData(db);
  }

  // Thêm dữ liệu mẫu
  Future _insertSampleData(Database db) async {
    await db.insert("contacts", {
      "name": "Nguyen Van A",
      "phone": "0123456789",
      "email": "a@example.com",
      "avatar": null,
    });

    await db.insert("contacts", {
      "name": "Tran Thi B",
      "phone": "0987654321",
      "email": "b@example.com",
      "avatar": null,
    });

    await db.insert("contacts", {
      "name": "Le Van C",
      "phone": "0909090909",
      "email": "c@example.com",
      "avatar": null,
    });
  }

  // Đóng DB
  Future close() async {
    final db = await instance.database;
    db.close();
  }

  // ========== CRUD ==========

  // Create
  Future<int> createContact(Contact contact) async {
    final db = await instance.database;
    return await db.insert('contacts', contact.toMap());
  }

  // Read all
  Future<List<Contact>> getAllContacts() async {
    final db = await instance.database;
    final result = await db.query('contacts');
    return result.map((map) => Contact.fromMap(map)).toList();
  }

  // Read by id
  Future<Contact?> getContactById(int id) async {
    final db = await instance.database;
    final maps = await db.query('contacts', where: 'id = ?', whereArgs: [id]);

    if (maps.isNotEmpty) {
      return Contact.fromMap(maps.first);
    }
    return null;
  }

  // Update
  Future<int> updateContact(Contact contact) async {
    final db = await instance.database;
    return await db.update(
      'contacts',
      contact.toMap(),
      where: 'id = ?',
      whereArgs: [contact.id],
    );
  }

  // Delete
  Future<int> deleteContact(int id) async {
    final db = await instance.database;
    return await db.delete('contacts', where: 'id = ?', whereArgs: [id]);
  }
}
