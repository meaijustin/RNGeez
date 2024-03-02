import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DecisionMakerScreen extends StatefulWidget {
  const DecisionMakerScreen({Key? key}) : super(key: key);

  @override
  State<DecisionMakerScreen> createState() => _DecisionMakerScreenState();
}

class _DecisionMakerScreenState extends State<DecisionMakerScreen> {
  final TextEditingController _itemController = TextEditingController();
  final List<String> _DecisionItems = [];

  void _addItem() {
    setState(() {
      final newItem = _itemController.text;
      if (newItem.isNotEmpty) {
        _DecisionItems.add(newItem);
        _itemController.clear();
      }
    });
  }

  void _removeItem(int index) {
    setState(() {
      _DecisionItems.removeAt(index);
    });
  }

  void _pickRandomItem() {
    if (_DecisionItems.isNotEmpty) {
      final random = Random();
      final randomItem = _DecisionItems[random.nextInt(_DecisionItems.length)];
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Your Pick!'),
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
  Future<void> _saveItems() async {
    final prefs = await SharedPreferences.getInstance();
    final setName = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        final controller = TextEditingController();
        return AlertDialog(
          title: const Text('Save As'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: 'Enter a name for this set'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(controller.text);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
    if (setName != null && setName.isNotEmpty) {
      await prefs.setStringList(setName, _DecisionItems);
    }
  }
  Future<void> _loadItems() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys().where((key) => key.startsWith('_Decision')).toList();
    final setName = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Load Set'),
          content: Container(
            width: double.maxFinite,
            height: 200, // Adjust this value as needed
            child: ListView.builder(
              itemCount: keys.length,
              itemBuilder: (context, index) => ListTile(
                title: Text(keys.elementAt(index)),
                onTap: () {
                  Navigator.of(context).pop(keys.elementAt(index));
                },
              ),
            ),
          ),
        );
      },
    );
    if (setName != null && setName.isNotEmpty) {
      setState(() {
        _DecisionItems.clear();
        _DecisionItems.addAll(prefs.getStringList(setName) ?? []);
      });
    }
  }

  Future<void> _deleteItems() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys().where((key) => key.startsWith('_Decision')).toList();
    final setName = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Set'),
          content: Container(
            width: double.maxFinite,
            height: 200, // Adjust this value as needed
            child: ListView.builder(
              itemCount: keys.length,
              itemBuilder: (context, index) => ListTile(
                title: Text(keys.elementAt(index)),
                onTap: () {
                  Navigator.of(context).pop(keys.elementAt(index));
                },
              ),
            ),
          ),
        );
      },
    );
    if (setName != null && setName.isNotEmpty) {
      prefs.remove(setName);
      setState(() {
        _DecisionItems.clear();
      });
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
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _saveItems,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Save Set'),
                ),
                const SizedBox(width: 5,),
                ElevatedButton(
                  onPressed: _loadItems,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Load Set'),
                ),
                const SizedBox(width: 5),
                ElevatedButton(
                  onPressed: _deleteItems,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Delete Set'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _DecisionItems.length,
                itemBuilder: (context, index) => ListTile(
                  title: Text(
                    _DecisionItems[index],
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
