import 'package:flutter/material.dart';

class MyFirstPage extends StatelessWidget {
  const MyFirstPage({super.key, required this.tittle, required this.name});
  final String tittle;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Main page'),
      ),
      body: Column(
        children: [
          SizedBox(height: 5),
          Text('Hello, $name', style: TextStyle(fontSize: 33)),
        ],
      ),
    );
  }
}
