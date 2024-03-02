import 'package:flutter/material.dart';
import 'dart:math';

class OutputScreen extends StatefulWidget {
  List<dynamic> leftShuffler;
  List<dynamic> rightShuffler;

  OutputScreen({
    Key? key,
    required this.leftShuffler,
    required this.rightShuffler,
  }) : super(key: key);

  @override
  State<OutputScreen> createState() => _OutputScreenState();
}

class _OutputScreenState extends State<OutputScreen> {
  late List<dynamic> leftItems;
  late List<dynamic> rightItems;

  @override
  void initState() {
    super.initState();
    leftItems = widget.leftShuffler;
    rightItems = _shuffle(widget.rightShuffler);
  }

  List<dynamic> _shuffle(List<dynamic> items) {
    var random = new Random();
    for (var i = items.length - 1; i > 0; i--) {
      var n = random.nextInt(i + 1);
      var temp = items[i];
      items[i] = items[n];
      items[n] = temp;
    }
    return items;
  }

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
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                rightItems = _shuffle(widget.rightShuffler);
              });
            },
            icon: Icon(Icons.shuffle, color: Theme.of(context).colorScheme.onPrimary),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: max(leftItems.length, rightItems.length),
        itemBuilder: (context, index) {
          if (index >= leftItems.length) return Container();
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(
                radius: 30,
                backgroundColor: Colors.grey[300],
                child: Text('Pair ${leftItems[index]}',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground,
                      fontWeight: FontWeight.bold,
                    )),
              ),
              title: Text('${leftItems[index]}',
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                  )),
              trailing: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('${rightItems[index % rightItems.length]}',
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
