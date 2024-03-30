import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:inside_company/model/opportunity.dart';
import 'package:inside_company/services/firestore/opportunitydb.dart';

class AddOpportunityPage extends StatefulWidget {
  @override
  _AddOpportunityPageState createState() => _AddOpportunityPageState();
}

class _AddOpportunityPageState extends State<AddOpportunityPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();

  void _addOpportunity() {
    Opportunity opportunity = Opportunity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      addedby: FirebaseAuth
          .instance.currentUser!.uid, // Assuming the admin adds opportunities
      name: _nameController.text,
      content: _contentController.text,
      status: "PENDING",
    );

    OpportunityDB().addOpportunity(opportunity).then((_) {
      // Clear text fields
      _nameController.clear();
      _contentController.clear();
      _statusController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Opportunity added successfully')),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error adding opportunity: $error")),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              decoration:const InputDecoration(labelText: 'Name'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _contentController,
              decoration: InputDecoration(labelText: 'Content'),
            ),
            SizedBox(height: 16.0),
            // TextField(
            //   controller: _statusController,
            //   decoration: InputDecoration(labelText: 'Status'),
            // ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _addOpportunity,
              child: Text('Add Opportunity'),
            ),
          ],
        ),
      ),
    );
  }
}
