import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/shopping_list_provider.dart';
import '../models/shopping_list.dart';
import '../models/shopping_item.dart';
import 'city_selection_modal.dart';

class AddShoppingListScreen extends StatefulWidget {
  @override
  _AddShoppingListScreenState createState() => _AddShoppingListScreenState();
}

class _AddShoppingListScreenState extends State<AddShoppingListScreen> {
  final _titleController = TextEditingController();
  final _marketNameController = TextEditingController();
  String _city = '';

  final List<TextEditingController> _itemControllers = [];

  void _addNewItem() {
    setState(() {
      _itemControllers.add(TextEditingController());
    });
  }

  void _removeItem(int index) {
    setState(() {
      _itemControllers.removeAt(index);
    });
  }

  void _openCitySelectionModal() async {
    final result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return CitySelectionModal();
      },
    );

    if (result != null && result is Map) {
      setState(() {
        _city = '${result['city']}, ${result['state']}';
      });
    }
  }

  void _saveShoppingList() {
    final items = _itemControllers.map((controller) {
      return ShoppingItem(name: controller.text);
    }).toList();

    final newList = ShoppingList(
      title: _titleController.text,
      marketName: _marketNameController.text,
      city: _city,
      items: items,
    );

    Provider.of<ShoppingListProvider>(context, listen: false)
        .addShoppingList(newList);

    Navigator.pop(context);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _marketNameController.dispose();
    _itemControllers.forEach((controller) => controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nova lista'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Titulo'),
            ),
            TextField(
              controller: _marketNameController,
              decoration: const InputDecoration(labelText: 'Nome do mercado'),
            ),
            GestureDetector(
              onTap: _openCitySelectionModal,
              child: AbsorbPointer(
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Cidade',
                    hintText: _city.isEmpty ? 'Selecione a localidade' : _city,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            Text('Items'),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: _itemControllers.length,
              itemBuilder: (context, index) {
                return Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _itemControllers[index],
                        decoration: InputDecoration(
                          labelText: 'Item ${index + 1}',
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.remove_circle),
                      onPressed: () => _removeItem(index),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _addNewItem,
              child: const Text('Adicionar item'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _saveShoppingList,
              child: const Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}
