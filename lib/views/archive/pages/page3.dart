import 'package:flutter/material.dart';

class Page3 extends StatefulWidget {
  const Page3({super.key});

  @override
  State<Page3> createState() => _Page3State();
}

class _Page3State extends State<Page3> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            decoration: InputDecoration(
              labelText: 'Date Prévue Livraison',
              border: OutlineInputBorder(),
            ),
            readOnly: true,
            onTap: () {
              // Show date picker
            },
          ),
          SizedBox(height: 20),
          TextField(
            decoration: InputDecoration(
              labelText: 'Date Réelle Livraison',
              border: const OutlineInputBorder(),
            ),
            readOnly: true,
            onTap: () {
              // Show date picker
            },
          ),
          SizedBox(height: 20),
          TextField(
            decoration: const InputDecoration(
              labelText: 'Date Réception Définitive',
              border: OutlineInputBorder(),
            ),
            readOnly: true,
            onTap: () {
              // Show date picker
            },
          ),
        ],
      ),
    );
  }
}
