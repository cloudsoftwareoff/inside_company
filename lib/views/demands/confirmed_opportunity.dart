import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:inside_company/model/opportunity.dart';
import 'package:inside_company/services/firestore/opportunitydb.dart';
import 'package:inside_company/views/demands/details.dart';

class ConfirmedOpportunity extends StatelessWidget {
  const ConfirmedOpportunity({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Opportunity>>(
        future: OpportunityDB().fetchOpportunitiesByState("CONFIRMED"),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No opportunities found.'));
          } else {
            List<Opportunity> opportunities = snapshot.data!;
            for (Opportunity opportunity in opportunities) {
              print("Materials: ${opportunity.material.join(', ')}");
            }
            return Padding(
              padding: const EdgeInsets.all(4.0),
              child: ListView.builder(
                itemCount: opportunities.length,
                itemBuilder: (context, index) {
                  Opportunity opportunity = opportunities[index];

                  return OpportunityCard(opportunity: opportunity);
                },
              ),
            );
          }
        },
      ),
    );
  }
}

class OpportunityCard extends StatelessWidget {
  final Opportunity opportunity;

  const OpportunityCard({Key? key, required this.opportunity})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 10,
      child: ListTile(
        title: Text(
          opportunity.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(
              "Description: ${opportunity.description}",
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 4),
            Text(
              "Budget: ${opportunity.budget.toStringAsFixed(2)} TND",
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 4),
            Text(
              "Materials: ${opportunity.material.join(', ')}",
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 4),
            Text(
              "Status: ${opportunity.status}",
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  OpportunityDetailsPage(opportunity: opportunity),
            ),
          );
        },
      ),
    );
  }
}
