import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:inside_company/notification/sender.dart';
import 'package:inside_company/providers/current_user.dart';
import 'package:intl/intl.dart';
import 'package:inside_company/model/demand.dart';
import 'package:inside_company/model/opportunity.dart';
import 'package:inside_company/services/firestore/demand_db.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';

class MakeDemandPage extends StatefulWidget {
  final Opportunity opportunity;
  final Demand? demandEdit;
  MakeDemandPage({Key? key, required this.opportunity, this.demandEdit}) : super(key: key);

  @override
  State<MakeDemandPage> createState() => _MakeDemandPageState();
}

class _MakeDemandPageState extends State<MakeDemandPage> {
  final TextEditingController _budgetController = TextEditingController();
  bool loading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.demandEdit !=null){
      _budgetController.text=widget.demandEdit!.budget.toString();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _budgetController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUserProvider = Provider.of<CurrentUserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Opportunity Details'),
      ),
      body: LoadingOverlay(
        isLoading: loading,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.opportunity.title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Description:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
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
                  Text(
                    'Budget:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  Text(
                  '${widget.opportunity.budget.toStringAsFixed(2)} TND',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Materials:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: widget.opportunity.material.map((material) {
                  return Dismissible(
                    key: Key(material),
                    onDismissed: (direction) {
                      setState(() {
                        widget.opportunity.material.remove(material);
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("$material removed"),
                          action: SnackBarAction(
                            label: 'Undo',
                            onPressed: () {
                              setState(() {
                                widget.opportunity.material.add(material);
                              });
                            },
                          ),
                        ),
                      );
                    },
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 16.0),
                      color: Colors.red,
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    child: Chip(
                      label: Text(material),
                      backgroundColor: Colors.blue,
                      labelStyle: const TextStyle(color: Colors.white),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Created At:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  Text(
                    DateFormat('MMM dd, yyyy - HH:mm a')
                        .format(widget.opportunity.timestamp!.toDate()),
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _budgetController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Enter Budget',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.all(16.0),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  setState(() {
                    loading = !loading;
                  });
                  if (_budgetController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please enter the budget."),
                      ),
                    );
                    setState(() {
                      loading = !loading;
                    });
                    return;
                  }
                  try {
                    await DemandDB().addDemand(
                      Demand(
                        id:widget.demandEdit !=null ?widget.demandEdit!.id: DateTime.now().millisecondsSinceEpoch.toString(),
                        opportunityId: widget.opportunity.id,
                        budget: double.parse(_budgetController.text),
                        state: "PENDING",
                        region: currentUserProvider.currentuser!.region,
                        materials: widget.opportunity.material,
                        dateDA: Timestamp.now(),
                      ),
                    );
                    sendNotification(
                        'der', widget.opportunity.title, "Demand", "Created");
                    _budgetController.clear();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Purchase demand updated successfully"),
                      ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Error: ${e.toString()}"),
                      ),
                    );
                  }
                  setState(() {
                    loading = !loading;
                  });
                },
                child: const Text(
                  'Confirm',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
