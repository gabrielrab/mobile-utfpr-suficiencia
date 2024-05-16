import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/shopping_item.dart';
import '../models/shopping_list.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'shopping_list.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE shopping_list (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        market_name TEXT,
        city TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE shopping_item (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        list_id INTEGER,
        name TEXT,
        is_checked INTEGER,
        FOREIGN KEY (list_id) REFERENCES shopping_list (id)
      )
    ''');
  }

  Future<int> insertShoppingList(ShoppingList list) async {
    final db = await database;
    int id = await db.insert('shopping_list', {
      'title': list.title,
      'market_name': list.marketName,
      'city': list.city,
    });

    for (var item in list.items) {
      await db.insert('shopping_item', {
        'list_id': id,
        'name': item.name,
        'is_checked': item.isChecked ? 1 : 0,
      });
    }

    return id;
  }

  Future<List<ShoppingList>> getShoppingLists() async {
    final db = await database;
    final listMaps = await db.query('shopping_list');
    final itemMaps = await db.query('shopping_item');

    List<ShoppingList> lists = [];

    for (var listMap in listMaps) {
      List<ShoppingItem> items = [];

      for (var itemMap in itemMaps) {
        if (itemMap['list_id'] == listMap['id']) {
          items.add(ShoppingItem(
            name: itemMap['name'] as String,
            isChecked: (itemMap['is_checked'] as int) == 1,
          ));
        }
      }

      lists.add(ShoppingList(
        title: listMap['title'] as String,
        marketName: listMap['market_name'] as String,
        city: listMap['city'] as String,
        items: items,
      ));
    }

    return lists;
  }
}
