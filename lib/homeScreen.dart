import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:randomiser/RNGeezer.dart';
import 'package:randomiser/decisionMaker.dart';
import 'package:randomiser/main.dart';
import 'package:randomiser/shuffler.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(context.watch<ThemeProvider>().themeMode == ThemeMode.dark
              ? Icons.light_mode
              : Icons.dark_mode),
          onPressed: () {
            bool isDark = context.read<ThemeProvider>().themeMode == ThemeMode.dark;
            context.read<ThemeProvider>().toggleTheme(!isDark);
          },

        ),

        title: const Text("RNGeez", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Theme.of(context).primaryColor,
      ),

      body:SingleChildScrollView(child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RNGeezScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.all(16.0),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text('Random Number Generator',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Colors.black,
                      )
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ShufflerScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.all(16.0),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text('Shuffler',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Colors.black
                      )
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const DecisionMakerScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.all(16.0),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text('Decision Maker',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Colors.black
                      )
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  //TODO: push to a random randomiser

                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.all(16.0),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text('Random Randomizer',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Colors.black,
                      )
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      )
    );
  }
}