import 'shopping_item.dart';

class ShoppingList {
  String title;
  String marketName;
  String city;
  List<ShoppingItem> items;

  ShoppingList({
    required this.title,
    required this.marketName,
    required this.city,
    required this.items,
  });
}
