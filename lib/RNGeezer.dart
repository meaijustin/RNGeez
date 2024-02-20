import 'dart:math';
import 'package:flutter/material.dart';

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

  void _generateValues() {
    final random = Random();
    final values = <int>[];
    for (int i = 0; i < _numValues; i++) {
      values.add(random.nextInt(_maxValue - _minValue + 1) + _minValue);
    }
    setState(() {
      _generatedValues = values;
    });
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