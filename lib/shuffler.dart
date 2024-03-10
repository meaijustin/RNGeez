import 'package:flutter/material.dart';
import 'package:randomiser/shuffler_output.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShufflerScreen extends StatefulWidget {
  const ShufflerScreen({Key? key}) : super(key: key);

  @override
  State<ShufflerScreen> createState() => _ShufflerScreenState();
}

class _ShufflerScreenState extends State<ShufflerScreen> {

  List<String> _leftElements = [];
  List<String> _rightElements = [];
  String _leftTitle="People";
  String _rightTitle="Numbers";
  final TextEditingController  _leftInputController= TextEditingController();
  final TextEditingController  _rightInputController= TextEditingController();
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
      await prefs.setString('leftTitle $setName', _leftTitle);
      await prefs.setString('rightTitle $setName', _rightTitle);
      await prefs.setStringList('leftElements $setName', _leftElements);
      await prefs.setStringList('rightElements $setName', _rightElements);
    }
  }

  Future<void> _loadParams() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys()
        .where((key) => key.startsWith('leftTitle '))
        .toList();
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
              itemBuilder: (context, index) =>
                  ListTile(
                    title: Text(keys.elementAt(index).substring(10)),
                    onTap: () {
                      Navigator.of(context).pop(keys.elementAt(index).substring(10));
                    },
                  ),
            ),
          ),
        );
      },
    );
    if (setName != null && setName.isNotEmpty) {
      setState(() {
        _leftTitle = prefs.getString('leftTitle $setName') ?? "People";
        _rightTitle = prefs.getString('rightTitle $setName') ?? "Numbers";
        _leftElements.clear();
        _leftElements.addAll(prefs.getStringList('leftElements $setName') ?? []);
        _rightElements.clear();
        _rightElements.addAll(prefs.getStringList('rightElements $setName') ?? []);
      });
    }
  }

  Future<void> _deleteParams() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys()
        .where((key) => key.startsWith('leftTitle '))
        .toList();
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
              itemBuilder: (context, index) =>
                  ListTile(
                    title: Text(keys.elementAt(index).substring(10)),
                    onTap: () {
                      Navigator.of(context).pop(keys.elementAt(index).substring(10));
                    },
                  ),
            ),
          ),
        );
      },
    );
    if (setName != null && setName.isNotEmpty) {
      prefs.remove('leftTitle $setName');
      prefs.remove('rightTitle $setName');
      prefs.remove('leftElements $setName');
      prefs.remove('rightElements $setName');
      setState(() {
        _leftTitle = "People";
        _rightTitle = "Numbers";
        _leftElements.clear();
        _rightElements.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                        padding: const EdgeInsets.all(1),
                        child: Column(
                          children: [
                            ListTile(
                              title: GestureDetector(
                                child: Text(
                                  _leftTitle,
                                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                    color: Theme.of(context).colorScheme.onSurface,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Edit Title'),
                                      content: TextFormField(
                                        initialValue: _leftTitle,
                                        decoration: const InputDecoration(
                                          hintText: 'New Title',
                                        ),
                                        onFieldSubmitted: (value) {
                                          Navigator.of(context).pop();
                                          setState(() {
                                            _leftTitle = value;
                                          });
                                        },
                                      ),
                                      actions: [
                                        TextButton(
                                          child: const Text('Cancel'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text('Add $_leftTitle'),
                                      content: TextFormField(
                                        controller: _leftInputController,
                                        decoration: InputDecoration(
                                          hintText: 'New $_leftTitle',
                                        ),
                                        onFieldSubmitted: (value) {
                                          setState(() {
                                            _leftElements.add(value);
                                          });
                                          _leftInputController.clear();
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      actions: [
                                        TextButton(
                                          child: const Text('Cancel'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                            Expanded(
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: _leftElements.length,
                                itemBuilder: (context, index) => ListTile(
                                  title: Text(
                                      _leftElements[index],
                                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                        color: Theme.of(context).colorScheme.onSurface,
                                        fontWeight: FontWeight.bold,
                                      ),
                                  ),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.remove),
                                    onPressed: () {
                                      setState(() {
                                        _leftElements.removeAt(index);
                                      });
                                    },
                                  ),
                                ),
                              ),
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
                        padding: const EdgeInsets.all(1),
                        child: Column(
                          children: [
                            ListTile(
                              title: GestureDetector(
                                child: Text(
                                  _rightTitle,
                                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                    color: Theme.of(context).colorScheme.onSurface,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                onTap: () {
                                  showDialog(

                                    context: context,
                                    builder: (context) => AlertDialog(

                                      title: const Text('Edit Title'),
                                      content: TextFormField(
                                        initialValue: _rightTitle,
                                        decoration: const InputDecoration(
                                          hintText: 'New Title',
                                        ),
                                        onFieldSubmitted: (value) {
                                          Navigator.of(context).pop();
                                          setState(() {
                                            _rightTitle = value;
                                          });
                                        },
                                      ),
                                      actions: [
                                        TextButton(
                                          child: const Text('Cancel'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text('Add $_rightTitle'),
                                      content: TextFormField(
                                        controller: _rightInputController,
                                        decoration: InputDecoration(
                                          hintText: 'New $_rightTitle',
                                        ),
                                        onFieldSubmitted: (value) {
                                          setState(() {
                                            _rightElements.add(value);
                                          });
                                          _rightInputController.clear();
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      actions: [
                                        TextButton(
                                          child: const Text('Cancel'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                            Expanded(
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: _rightElements.length,
                                itemBuilder: (context, index) => ListTile(
                                  title: Text(
                                    _rightElements[index],
                                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                      color: Theme.of(context).colorScheme.onSurface,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.remove),
                                    onPressed: () {
                                      setState(() {
                                        _rightElements.removeAt(index);
                                      });
                                    },
                                  ),
                                ),
                              ),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (_leftElements.isEmpty || _rightElements.isEmpty){
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            showCloseIcon: true,
                            content: Text('Input at least one element in each list!'),
                        )
                      );
                    }
                    else{
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OutputScreen(
                            leftTitle:_leftTitle,
                            rightTitle:_rightTitle,
                            leftShuffler: _leftElements,
                            rightShuffler: _rightElements,
                          ),
                        ),
                      );
                    }
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
                const SizedBox(width: 5),
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
                const SizedBox(width: 5),
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
                const SizedBox(width: 5),
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
          ],
        ),
      ),
    );
  }
}