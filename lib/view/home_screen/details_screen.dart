import 'package:flutter/material.dart';

class DetailsScreen extends StatelessWidget {
  static const routeName = 'details_screen';
  const DetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Details'),
      ),
      body: Container(),
    );
  }
}
