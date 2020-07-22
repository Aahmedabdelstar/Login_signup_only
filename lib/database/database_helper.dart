import 'dart:async';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = new DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;

  static Database _db;

  Future<Database> get db async {
    if (_db != null) return _db;
    _db = await initDb();
    return _db;
  }

  DatabaseHelper.internal();

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "megggR.db");
    var theDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return theDb;
  }

  void _onCreate(Database db, int version) async {
    // When creating the db, create the table
    await db.execute(
        "CREATE TABLE favourite(id INTEGER PRIMARY KEY, productPath TEXT , category TEXT)");

    await db.execute(
        "CREATE TABLE basket(id INTEGER PRIMARY KEY, productPath TEXT , category TEXT , quantity INTEGER)");


    await db.execute(
        "CREATE TABLE orderss(id INTEGER PRIMARY KEY, orderId TEXT , regionID TEXT , totalSalary TEXT , orderDate TEXT)");
  }


  // add order for customer in the database
  Future<int> addOrderForCustomer(String orderId, String regionID, String totalSalary ,String orderDate) async {

    print("added,,,,,,,,,,,,,,,,,,,,,suuccessflyt...");
    var dbClient = await db;
    var map = new Map<String, dynamic>();
    map["orderId"] = orderId;
    map["regionID"] = regionID;
    map["totalSalary"] = totalSalary;
    map["orderDate"] = orderDate;
    int res = await dbClient.insert("orderss", map).whenComplete((){
      print("successflu");
    });
    return res;
  }


  Future<bool> isProductInBasket(String productId) async {
    var dbClient = await db;
    List<Map> productList = await dbClient
        .rawQuery('SELECT * FROM basket where productPath = ?', [productId]);
    if (productList.length > 0) {

      print("true");
      return true;
    }
    print("false");
    return false;
  }


  Future<int> getProductQuantityFromBasket(String productId) async {
    var dbClient = await db;
    List<Map> list = await dbClient
        .rawQuery('SELECT * FROM basket where productPath = ?', [productId]);

     if(list == null || list.length == 0){
        return 0;
     }return list.elementAt(0)["quantity"];
  }
  Future<bool> isProductFoundInBasketTable(String productId) async {
    var dbClient = await db;
    List<Map> productList = await dbClient
        .rawQuery('SELECT * FROM basket where productPath = ?', [productId]);
    if (productList.length > 0) {
      return true;
    }
    return false;
  }

  Future<int> addProductIntoBasket(String productId, String category, int quantity ) async {
    bool found = await isProductFoundInBasketTable(productId);
    if (found == true ) {
      await deleteProductInBasket(productId);
    }
    if(quantity == 0) {
      await deleteProductInBasket(productId);
      return 0;
    }

    var dbClient = await db;
    var map = new Map<String, dynamic>();
    map["productPath"] = productId;
    map["category"] = category;
    map["quantity"] = quantity;
    int res = await dbClient.insert("basket", map);
    return res;
  }

  Future<int> deleteProductInBasket(String productId) async {
    var dbClient = await db;
    int res = await dbClient
        .rawDelete('DELETE FROM basket WHERE productPath = ?', [productId]);
    return res;
  }

  Future<int> incrementProductInBasket(String productId, String category) async {
    bool found = await isProductInBasket(productId);
    if (found == true) {
      int quantity = await getProductQuantityFromBasket(productId);
      quantity = quantity + 1;
      print(quantity);
      deleteProductInBasket(productId);
      addProductIntoBasket(productId, category, quantity);
      return quantity;
    } else {
      addProductIntoBasket(productId, category, 1);
      return 1;
    }
  }

  Future<int> decrementProductInBasket(String productId, String category) async {
    var dbClient = await db;
    if (await isProductInBasket(productId) == true) {
      int quantity = await getProductQuantityFromBasket(productId);
      if (quantity > 1) {
        quantity = quantity - 1;
        deleteProductInBasket(productId);
        addProductIntoBasket(productId, category, quantity);
        return quantity;
      } else {
        deleteProductInBasket(productId);
        return 0;
      }
    }
  }

  Future<int> addProductToFavourite(String productPath, String category) async {
    var dbClient = await db;
    var map = new Map<String, dynamic>();
    map["productPath"] = productPath;
    map["category"] = category;
    int res = await dbClient.insert("favourite", map);
    return res;
  }

  Future<bool> isProductFoundInFavouriteTable(String productId) async {
    var dbClient = await db;
    List<Map> productList = await dbClient
        .rawQuery('SELECT * FROM favourite where productPath = ?', [productId]);
    if (productList.length > 0) {
      return true;
    }
    return false;
  }

  Future<int> deleteUsers(String productPath) async {
    var dbClient = await db;

    int res = await dbClient.rawDelete(
        'DELETE FROM favourite WHERE productPath = ?', [productPath]);
    return res;
  }
}
