import 'package:flutter/material.dart';
import 'package:randomiser/shufflerOutput.dart';

class ShufflerScreen extends StatefulWidget {
  const ShufflerScreen({Key? key}) : super(key: key);

  @override
  State<ShufflerScreen> createState() => _ShufflerScreenState();
}

class _ShufflerScreenState extends State<ShufflerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Shuffler',
          style: Theme.of(context).textTheme.headlineMedium!.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
          backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(3),
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  Expanded(
                    child: Card(
                      color: Theme.of(context).colorScheme.surface,
                      child: Padding(
                        padding: const EdgeInsets.all(3),
                        child: Column(
                          children: [
                            ListTile(
                              title: Text(
                                'People',
                                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                  color: Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                            ),
                            Expanded(
                              child: ListView.builder(
                                itemCount: 0, // Placeholder for list entries
                                itemBuilder: (context, index) => ListTile(
                                  title: Text('Person $index'),
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () => {}, //TODO: implement adding
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Card(
                      color: Theme.of(context).colorScheme.surface,
                      child: Padding(
                        padding: const EdgeInsets.all(3),
                        child: Column(
                          children: [
                            ListTile(
                              title: Text(
                                'Numbers',
                                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                  color: Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                            ),
                            Expanded(
                              child: ListView.builder(
                                itemCount: 0, // Placeholder for list entries
                                itemBuilder: (context, index) => ListTile(
                                  title: Text('Number $index'),
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () => {}, //TODO: implement adding
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const OutputScreen()),
                ),
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                backgroundColor: Theme.of(context).colorScheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Shuffle'),
            ),
          ],
        ),
      ),
    );
  }
}