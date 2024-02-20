import 'dart:math';
import 'package:flutter/material.dart';

class DecisionMakerScreen extends StatefulWidget {
  const DecisionMakerScreen({Key? key}) : super(key: key);

  @override
  State<DecisionMakerScreen> createState() => _DecisionMakerScreenState();
}

class _DecisionMakerScreenState extends State<DecisionMakerScreen> {
  final TextEditingController _itemController = TextEditingController();
  final List<String> _items = [];

  void _addItem() {
    setState(() {
      final newItem = _itemController.text;
      if (newItem.isNotEmpty) {
        _items.add(newItem);
        _itemController.clear();
      }
    });
  }
  void _removeItem(int index) {
    setState(() {
      _items.removeAt(index);
    });
  }
  void _pickRandomItem() {
    if (_items.isNotEmpty) {
      final random = Random();
      final randomItem = _items[random.nextInt(_items.length)];
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Random Item'),
            content: Text(randomItem),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Decision Maker',
          style: Theme.of(context).textTheme.headlineMedium!.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _itemController,
              decoration: InputDecoration(
                labelText: 'Add Item',
                labelStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                border: const OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addItem,
              style: ElevatedButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                backgroundColor: Theme.of(context).colorScheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Add'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickRandomItem,
              style: ElevatedButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                backgroundColor: Theme.of(context).colorScheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Pick Random Item'),
            ),
            const SizedBox(height:  20),
            Expanded(
              child: ListView.builder(
                itemCount: _items.length,
                itemBuilder: (context, index) => ListTile(
                  title: Text(
                    _items[index],
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.close),
                    color: Theme.of(context).colorScheme.onSurface,
                    onPressed: () => _removeItem(index),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}