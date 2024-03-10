import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class OutputsScreen extends StatelessWidget {
  const OutputsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final storage = FlutterSecureStorage();
    return FutureBuilder<String?>(
      future: storage.read(key: 'device_id'),
      builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        final deviceId = snapshot.data;
        return Scaffold(
          appBar: AppBar(
            title: const Text('Your Saved Outputs'),
          ),
          body: deviceId == null
              ? const Text('Device ID not found.')
              : ListView(
            children: [
              _buildCollection(context, theme, 'decisions', deviceId),
              _buildCollection(context, theme, 'rngValues', deviceId),
              _buildCollection(context, theme, 'shuffledItems', deviceId),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCollection(BuildContext context, ThemeData theme, String collectionName, String deviceId) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection(collectionName).where('deviceId', isEqualTo: deviceId).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(collectionName.substring(0,1).toUpperCase()+collectionName.substring(1), style: theme.textTheme.bodyLarge),
            ),
            ...snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data = document.data() as Map<String, dynamic>;
              data.remove('deviceId'); // Remove the device ID
              return Card(
                margin: const EdgeInsets.all(8.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: data.entries.map((e) => Text('${e.key.substring(0,1).toUpperCase()}${e.key.substring(1)}: ${e.value}', style: theme.textTheme.bodyMedium)).toList(),
                  ),
                ),
              );
            }).toList(),
          ],
        );
      },
    );
  }
}