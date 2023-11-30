import 'package:flutter/material.dart';

class Expeneses extends StatefulWidget {
  const Expeneses({super.key});

  @override
  State<Expeneses> createState() => _ExpenesesState();
}

class _ExpenesesState extends State<Expeneses> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        children: [
          Text("The Chart"),
          Text("Expenses list"),
        ],
      ) ,

    );
  }
}