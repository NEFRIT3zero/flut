import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flut/models/product.dart';
import 'package:flut/models/user.dart';
import 'package:flut/services/firebase_service.dart';

class DatabaseController {
  static final DatabaseController instance = DatabaseController._internal();
  factory DatabaseController() => instance;
  DatabaseController._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'shop_database.db');

    // await deleteDatabase(path);

    return await openDatabase(
      path,
      version: 3,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE products(
        qrData TEXT PRIMARY KEY NOT NULL,
        name TEXT NOT NULL,
        imageBytes BLOB,
        reservedBy TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE users(
        login TEXT PRIMARY KEY NOT NULL,
        name TEXT NOT NULL,
        password TEXT NOT NULL,
        isAdmin INTEGER NOT NULL DEFAULT 0
      )
    ''');

    print("Database and table created!");
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE users(
          login TEXT PRIMARY KEY NOT NULL,
          name TEXT NOT NULL,
          password TEXT NOT NULL
        )
      ''');
      print("Users table added during upgrade.");
    }
    if (oldVersion < 3) {
      await db.execute('''
      ALTER TABLE users
      ADD COLUMN isAdmin INTEGER NOT NULL DEFAULT 0
    ''');
      await db.execute('''
      ALTER TABLE products
      ADD COLUMN reservedBy TEXT
    ''');
    }
  }

  //-------------------------------------------------------------------------

  Future<void> insertProduct(Product product, {bool local = false}) async {
    final db = await database;
    await db.insert(
      'products',
      product.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    if (!local) {
      await FirebaseService.instance.uploadProduct(product);
    }

    print('inserted product ${product.toMap()}');
  }

  Future<List<Product>> getProducts() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('products');
    return maps.map((map) => Product.fromMap(map)).toList();
  }

  Future<Product?> getProductByQrCode(String qrCode) async {
    final db = await database;
    final List<Map<String, Object?>> result = await db.query(
      'products',
      where: 'qrData = ?',
      whereArgs: [qrCode],
      limit: 1,
    );

    if (result.isNotEmpty) {
      return Product.fromMap(result.first);
    }
    return null;
  }

  Future<void> reserveProduct(Product product, User user) async {
    final db = await database;
    await db.update(
      'products',
      {'reservedBy': user.login},
      where: 'qrData = ?',
      whereArgs: [product.qrData],
    );

    // final updatedProduct = Product(
    //   qrData: product.qrData,
    //   name: product.name,
    //   imageBytes: product.imageBytes,
    //   reservedBy: user.login,
    // );

    await FirebaseService.instance.updateProduct(product, user.login);
  }

  Future<void> unreserveProduct(Product product) async {
    final db = await database;
    await db.update(
      'products',
      {'reservedBy': null},
      where: 'qrData = ?',
      whereArgs: [product.qrData],
    );

    // final updatedProduct = Product(
    //   qrData: product.qrData,
    //   name: product.name,
    //   imageBytes: product.imageBytes,
    //   reservedBy: null,
    // );

    await FirebaseService.instance.updateProduct(product, null);
  }

  //---------------------------------------------------------------
  Future<void> insertUser(User user, {bool local = false}) async {
    final db = await database;
    await db.insert(
      'users',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    if (!local) {
      await FirebaseService.instance.uploadUser(user);
    }
  }

  Future<User?> authorizeUser(String login, String password) async {
    final db = await database;
    final List<Map<String, Object?>> result = await db.query(
      'users',
      where: 'login = ? AND password = ?',
      whereArgs: [login, password],
      limit: 1,
    );

    if (result.isNotEmpty) {
      return User.fromMap(result.first);
    }
    return null;
  }

  //---------------------------------------------------------------

  Future<void> syncProductsToFirebase() async {
    final db = DatabaseController.instance;
    final firebase = FirebaseService();

    final products = await db.getProducts();

    for (final product in products) {
      await firebase.uploadProduct(product);
    }
  }

  Future<void> syncFromFirebase() async {
    final products = await FirebaseService.instance.downloadProducts();

    for (final product in products) {
      await insertProduct(product, local: true);
    }

    final users = await FirebaseService.instance.downloadUsers();

    for (final user in users) {
      await insertUser(user, local: true);
    }
  }
}
