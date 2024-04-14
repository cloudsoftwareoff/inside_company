import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:inside_company/constant.dart';
import 'package:inside_company/model/opportunity.dart';
import 'package:inside_company/services/firestore/opportunitydb.dart';

class AddOpportunityPage extends StatefulWidget {
  @override
  _AddOpportunityPageState createState() => _AddOpportunityPageState();
}

class _AddOpportunityPageState extends State<AddOpportunityPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();
  final TextEditingController _budgetController = TextEditingController();
  final TextEditingController _materialController = TextEditingController();
  List<String> _materials = [];

  void _addOpportunity() {
    Opportunity opportunity = Opportunity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      addedBy: FirebaseAuth
          .instance.currentUser!.uid, // Assuming the admin adds opportunities
      title: _titleController.text,
      description: _descriptionController.text,
      budget: double.parse(_budgetController.text),
      material: _materials,
      timestamp: Timestamp.now(),
      lastModified: Timestamp.now(),
      status: "PENDING",
    );

    OpportunityDB().addOpportunity(opportunity).then((_) {
      // Clear text fields
      _titleController.clear();
      _descriptionController.clear();
      _statusController.clear();
      _budgetController.clear();
      setState(() {
        _materials.clear();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Opportunity added successfully')),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error adding opportunity: $error")),
      );
    });
  }

  void _addMaterial(String material) {
    setState(() {
      _materials.add(material);
      _materialController.clear();
    });
  }

  void _removeMaterial(String material) {
    setState(() {
      _materials.remove(material);
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _budgetController.dispose();
    _titleController.dispose();
    _statusController.dispose();
    _materialController.dispose();
    _descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _budgetController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Budget',
                border: OutlineInputBorder(),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _materialController,
              decoration: const InputDecoration(
                labelText: 'Add Material (, or ENTER)',
                border: OutlineInputBorder(),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
              ),
              onChanged: (value) {
                if (value.endsWith(',')) {
                  String material = value.substring(0, value.length - 1).trim();
                  if (material.isNotEmpty) {
                    _addMaterial(material);
                    _materialController.clear();
                  }
                }
              },
              onSubmitted: _addMaterial,
            ),
            // ListView.builder(
            //   shrinkWrap: true,
            //   itemCount: _matchingMaterials.length,
            //   itemBuilder: (context, index) {
            //     return ListTile(
            //       title: Text(_matchingMaterials[index]),
            //       onTap: () => _addMaterial(_matchingMaterials[index]),
            //     );
            //   },
            // ),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: _materials.map((material) {
                return Chip(
                  label: Text(material),
                  onDeleted: () => _removeMaterial(material),
                );
              }).toList(),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _addOpportunity,
              child: const Text('Add Opportunity'),
            ),
          ],
        ),
      ),
    );
  }
}
