import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'main.dart';

class RNGeezScreen extends StatefulWidget {
  const RNGeezScreen({Key? key}) : super(key: key);

  @override
  State<RNGeezScreen> createState() => _RNGeezScreenState();
}
class _RNGeezScreenState extends State<RNGeezScreen> {

  int _minValue = 0;
  int _maxValue = 100;
  int _numValues = 1;
  List<int> _generatedValues = [];
  final TextEditingController _minValueController = TextEditingController();
  final TextEditingController _maxValueController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  void _generateValues() {
    final random = Random();
    final values = <int>[];
    for (int i = 0; i < _numValues; i++) {
      values.add(random.nextInt(_maxValue - _minValue + 1) + _minValue);
    }
    setState(() {
      _generatedValues = values;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Save output?'),
        action: SnackBarAction(
          label: 'Yes',
          onPressed: () async {
            String? deviceId = await storage.read(key: 'device_id');
            CollectionReference rngValues = FirebaseFirestore.instance.collection('rngValues');
            await rngValues.add({
              'deviceId': deviceId,
              'minValue': _minValue,
              'maxValue': _maxValue,
              'numValues': _numValues,
              'generatedValues': _generatedValues,
            });
          },
        ),
      ),
    );
  }
  Future<void> _saveParams() async {
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
      await prefs.setString('RNG_${setName}', '$_minValue,$_maxValue,$_numValues');
    }
  }

  Future<void> _loadParams() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys().where((key) => key.startsWith('RNG_')).toList();
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
                title: Text(keys.elementAt(index).substring(4)), // Remove the 'RNG_' prefix
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
      final values = prefs.getString(setName)?.split(',');
      setState(() {
        _minValue = int.parse(values![0]);
        _maxValue = int.parse(values[1]);
        _numValues = int.parse(values[2]);
        _minValueController.text = "$_minValue";
        _maxValueController.text = "$_maxValue";
        _amountController.text = "$_numValues";
      });
    }
  }

  Future<void> _deleteParams() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys().where((key) => key.startsWith('RNG_')).toList();
    final setName = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Set'),
          content: Container(
            width: double.maxFinite,
            height: 200,
            child: ListView.builder(
              itemCount: keys.length,
              itemBuilder: (context, index) => ListTile(
                title: Text(keys.elementAt(index).substring(4)),
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
        _minValueController.clear();
        _maxValueController.clear();
        _amountController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'RNGeez',
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
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _minValueController,
                    decoration: InputDecoration(
                      labelText: 'Minimum Value',
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
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        _minValue = int.tryParse(value) ?? 0;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: TextField(
                    controller: _maxValueController,
                    decoration: InputDecoration(
                      labelText: 'Maximum Value',
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
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        _maxValue = int.tryParse(value) ?? 100;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _amountController,
              decoration: InputDecoration(
                labelText: 'Number of Values',
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
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  _numValues = int.tryParse(value) ?? 1;
                });
              },
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _generateValues,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Generate'),
                ),
                ElevatedButton(
                  onPressed: _saveParams,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Save'),
                ),
                ElevatedButton(
                  onPressed: _loadParams,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Load'),
                ),
                ElevatedButton(
                  onPressed: _deleteParams,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Delete'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _generatedValues.length,
                itemBuilder: (context, index) => ListTile(
                  title: Text(

                    'Value ${index + 1}: ${_generatedValues[index]}',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
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