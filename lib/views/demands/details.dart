import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

import 'package:inside_company/model/demand.dart';
import 'package:inside_company/model/opportunity.dart';
import 'package:inside_company/services/firestore/demand_db.dart';
import 'package:intl/intl.dart';
import 'package:loading_overlay/loading_overlay.dart';

class OpportunityDetailsPage extends StatefulWidget {
  final Opportunity opportunity;

  OpportunityDetailsPage({Key? key, required this.opportunity})
      : super(key: key);

  @override
  State<OpportunityDetailsPage> createState() => _OpportunityDetailsPageState();
}

class _OpportunityDetailsPageState extends State<OpportunityDetailsPage> {
  final TextEditingController _budgetController = TextEditingController();
  bool loading = false;
  @override
  void dispose() {
    super.dispose();
    _budgetController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Opportunity Details'),
      ),
      body: LoadingOverlay(
        isLoading: loading,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.opportunity.title,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Description',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.opportunity.description,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Budget',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${widget.opportunity.budget.toStringAsFixed(2)} TND',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Materials',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: widget.opportunity.material.map((material) {
                      return Chip(
                        label: Text(material),
                        backgroundColor: Colors.blue,
                        labelStyle: const TextStyle(color: Colors.white),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Created At:',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        DateFormat('MMM dd, yyyy - HH:mm a')
                            .format(widget.opportunity.timestamp!.toDate()),
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),
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
              ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      loading = !loading;
                    });
                    if (_budgetController.text == '') {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("Add the budget please")));
                      setState(() {
                        loading = !loading;
                      });
                      return;
                    }
                    try {
                      await DemandDB().addDemand(Demand(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          opportunityId: widget.opportunity.id,
                          budget: double.parse(_budgetController.text),
                          state: "PENDING",
                          dateDA: Timestamp.now()));
                      _budgetController.clear();
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("Purchase demand added successfully")));
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Error: ${e.toString()}")));
                    }
                    setState(() {
                      loading = !loading;
                    });
                  },
                  child: const Text(
                    'Confirm',
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
