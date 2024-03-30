import 'package:flutter/material.dart';
import 'package:inside_company/model/opportunity.dart';
import 'package:inside_company/services/firestore/opportunitydb.dart';

class ViewAllOpportunitiesPage extends StatelessWidget {
  const ViewAllOpportunitiesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Opportunity>>(
        future: OpportunityDB().fetchOpportunities(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No opportunities found.'));
          } else {
            List<Opportunity> opportunities = snapshot.data!;
            return ListView.builder(
              itemCount: opportunities.length,
              itemBuilder: (context, index) {
                Opportunity opportunity = opportunities[index];
                return ListTile(
                  title: Text(opportunity.name),
                  subtitle: Text(opportunity.content),
                  trailing: opportunity.status == "PENDING"
                      ? const Icon(Icons.pending,
                      color: Colors.amber,
                      )
                      : opportunity.status == "CONFIRMED"
                          ? const Icon(Icons.done_all_rounded,
                          color: Colors.green,)
                          : const Icon(Icons.clear_all_rounded,
                          color: Colors.red,),
                  
                );
              },
            );
          }
        },
      ),
    );
  }
}
