import 'package:flutter/material.dart';

class OutputScreen extends StatelessWidget {
  const OutputScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text(
          'Randomised Result',
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
            color: Theme.of(context).colorScheme.onBackground,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        elevation:  0,
        actions: [
          IconButton(
            onPressed: () {}, //TODO: gotta implement shuffling fr fr
            icon: Icon(Icons.shuffle, color: Theme.of(context).colorScheme.onPrimary),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount:  2, // Number of people and numbers to display
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(vertical:  8.0),
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(
                radius:  30,
                backgroundColor: Colors.grey[300],
                child: Text('P${index +  1}',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground,
                      fontWeight: FontWeight.bold,
                    )),
              ),
              title: Text('Person ${index +  1}',
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                  )),
              trailing: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Number ${index +  1}',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground,
                    )),
              ),
            ),
          );
        },
      ),
    );
  }
}
