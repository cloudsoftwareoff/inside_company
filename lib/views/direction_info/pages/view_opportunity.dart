import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:inside_company/model/opportunity.dart';
import 'package:inside_company/services/firestore/opportunitydb.dart';

class ViewAllOpportunitiesPage extends StatelessWidget {
  final String state;
  const ViewAllOpportunitiesPage({super.key,
  required this.state});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Opportunity>>(
        future: state== "ALL" ? OpportunityDB().fetchOpportunities(): OpportunityDB().fetchOpportunitiesByState(state),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No opportunities found.'));
          } else {
            List<Opportunity> opportunities = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(4.0),
              child: ListView.builder(
                itemCount: opportunities.length,
                itemBuilder: (context, index) {
                  Opportunity opportunity = opportunities[index];
                  return Card(
                    color: Colors.white,
                    elevation: 10,
                    child: ListTile(
                      title: Text(opportunity.title),
                      subtitle: Text(opportunity.description),
                      trailing: opportunity.status == "PENDING"
                          ? Icon(
                              Icons.pending_actions,
                              color: Colors.amber,
                            )
                          : opportunity.status == "CONFIRMED"
                              ? const Icon(
                                  Icons.done_all_rounded,
                                  color: Colors.green,
                                )
                              : const Icon(
                                  Icons.undo,
                                  color: Colors.red,
                                ),
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}