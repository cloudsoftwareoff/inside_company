import 'package:flutter/material.dart';

import 'package:inside_company/components/op_details.dart';
import 'package:inside_company/components/opportunity_card.dart';
import 'package:inside_company/model/opportunity.dart';
import 'package:inside_company/services/firestore/opportunity_db.dart';
import 'package:inside_company/views/direction_info/pages/add_opportunity.dart';

class ViewAllOpportunitiesPage extends StatelessWidget {
  final String state;
  const ViewAllOpportunitiesPage({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Opportunity>>(
        future: state == "ALL"
            ? OpportunityDB().fetchOpportunities()
            : OpportunityDB().fetchOpportunitiesByState(state),
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
                  return GestureDetector(
                    onLongPress: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              AddOpportunityPage(opportunityEdit: opportunity),
                        ),
                      );
                    },
                    child: OpportunityColoredCard(
                      opportunity: opportunity,
                      onClick: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OpportunityDetailWidget(
                                opportunity: opportunity),
                          ),
                        );
                      },
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
