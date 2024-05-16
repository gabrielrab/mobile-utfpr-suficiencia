import 'package:flutter/material.dart';
import '../models/shopping_list.dart';
import '../db/database_helper.dart';

class ShoppingListProvider with ChangeNotifier {
  List<ShoppingList> _shoppingLists = [];
  final DatabaseHelper _dbHelper = DatabaseHelper();

  ShoppingListProvider() {
    _loadShoppingLists();
  }

  List<ShoppingList> get shoppingLists => _shoppingLists;

  Future<void> _loadShoppingLists() async {
    _shoppingLists = await _dbHelper.getShoppingLists();
    notifyListeners();
  }

  Future<void> addShoppingList(ShoppingList list) async {
    await _dbHelper.insertShoppingList(list);
    _shoppingLists = await _dbHelper.getShoppingLists();
    notifyListeners();
  }
}
