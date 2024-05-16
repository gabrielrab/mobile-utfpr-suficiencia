import 'package:flutter/material.dart';
import '../models/shopping_list.dart';

class ShoppingListTile extends StatelessWidget {
  final ShoppingList list;
  final VoidCallback onTap;

  ShoppingListTile({required this.list, required this.onTap});

  @override
  Widget build(BuildContext context) {
    bool allItemsChecked = list.items.every((item) => item.isChecked);
    Color titleColor = allItemsChecked ? Colors.red : Colors.green;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.all(8),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              list.title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: titleColor,
              ),
            ),
            SizedBox(height: 8),
            Text(
              list.marketName,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 4),
            Text(
              list.city,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
