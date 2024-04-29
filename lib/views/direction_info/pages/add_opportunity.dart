import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:inside_company/constant.dart';
import 'package:inside_company/model/opportunity.dart';
import 'package:inside_company/notification/sender.dart';
import 'package:inside_company/providers/current_user.dart';
import 'package:inside_company/services/firestore/opportunity_db.dart';
import 'package:provider/provider.dart';

class AddOpportunityPage extends StatefulWidget {
  const AddOpportunityPage({super.key});

  @override
  _AddOpportunityPageState createState() => _AddOpportunityPageState();
}

class _AddOpportunityPageState extends State<AddOpportunityPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _budgetController = TextEditingController();
  final TextEditingController _materialController = TextEditingController();
  final List<String> _materials = [];

  void _addOpportunity() {
    if (_titleController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _budgetController.text.isEmpty ||
        _materials.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    try {
      double.parse(_budgetController.text);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Budget must be a valid number')),
      );
      return;
    }
    final currentUserProvider =
        Provider.of<CurrentUserProvider>(context, listen: false);
    String _id = DateTime.now().millisecondsSinceEpoch.toString();
    Opportunity opportunity = Opportunity(
      id: _id,
      addedBy: FirebaseAuth.instance.currentUser!.uid,
      title: _titleController.text,
      description: _descriptionController.text,
      budget: double.parse(_budgetController.text),
      material: _materials,
      region: currentUserProvider.currentuser!.region,
      timestamp: Timestamp.now(),
      lastModified: Timestamp.now(),
      status: "PENDING",
    );

    OpportunityDB().addOpportunity(opportunity).then((_) {
      //Send Notification
      sendNotification("invest", _titleController.text, "Opportunity", "Pending");
      _titleController.clear();
      _descriptionController.clear();
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
    super.dispose();
    _budgetController.dispose();
    _titleController.dispose();
    _materialController.dispose();
    _descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: _budgetController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Budget (TND)',
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _materialController,
                    decoration: const InputDecoration(
                      labelText: 'Add Material',
                      border: const OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      if (value.endsWith(',')) {
                        String material =
                            value.substring(0, value.length - 1).trim();
                        if (material.isNotEmpty) {
                          _addMaterial(material);
                          _materialController.clear();
                        }
                      }
                    },
                    onFieldSubmitted: _addMaterial,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => _addMaterial(_materialController.text),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
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
