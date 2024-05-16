import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/shopping_list.dart';
import '../providers/shopping_list_provider.dart';
import 'map_modal.dart';

class ShoppingListDetailScreen extends StatelessWidget {
  final ShoppingList shoppingList;

  ShoppingListDetailScreen({required this.shoppingList});

  void _openMapModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return MapModal();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(shoppingList.title),
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<ShoppingListProvider>(
              builder: (context, provider, child) {
                return ListView.builder(
                  itemCount: shoppingList.items.length,
                  itemBuilder: (context, index) {
                    final item = shoppingList.items[index];
                    return CheckboxListTile(
                      title: Text(item.name),
                      value: item.isChecked,
                      onChanged: (bool? value) {
                        item.isChecked = value ?? false;
                        provider.notifyListeners(); // Updates
                      },
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _openMapModal(context),
                child: Text('Onde estou ?'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
