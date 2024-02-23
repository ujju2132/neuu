import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CSV Export',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CSVExportScreen(),
    );
  }
}

class CSVExportScreen extends StatefulWidget {
  @override
  _CSVExportScreenState createState() => _CSVExportScreenState();
}

class _CSVExportScreenState extends State<CSVExportScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  List<List<dynamic>> dataRows = [
    ['Name', 'Age', 'Email']
  ];

  void addDataToList() {
    setState(() {
      dataRows.add([
        nameController.text,
        ageController.text,
        emailController.text,
      ]);
      nameController.clear();
      ageController.clear();
      emailController.clear();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('added to the list'),
      ),
    );
  }

  Future<String> getFilePath() async {
    Directory? directory;
    if (Platform.isAndroid) {
      directory = await getExternalStorageDirectory();
    } else if (Platform.isIOS) {
      directory = await getApplicationDocumentsDirectory();
    }
    if (directory == null) {
      throw 'Could not determine the storage directory';
    }
    return '${directory.path}/data.csv';
  }

  Future<void> exportToCSV() async {
    String csv = const ListToCsvConverter().convert(dataRows);
    String csvFilePath = await getFilePath();
    File csvFile = File(csvFilePath);
    await csvFile.writeAsString(csv);
    // Show feedback to the user that the CSV file has been saved
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('CSV file exported successfully'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CSV Export'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: ageController,
              decoration: InputDecoration(labelText: 'Age'),
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: addDataToList,
              child: Text('Add Data'),
            ),
            ElevatedButton(
              onPressed: exportToCSV,
              child: Text('Export to CSV'),
            ),
          ],
        ),
      ),
    );
  }
}
