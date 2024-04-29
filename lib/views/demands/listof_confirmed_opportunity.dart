import 'package:flutter/material.dart';
import 'package:inside_company/components/confirmed_opportunity_card.dart';
import 'package:inside_company/model/opportunity.dart';
import 'package:inside_company/services/firestore/opportunity_db.dart';
import 'package:inside_company/views/demands/make_demand.dart';
import 'package:loading_overlay/loading_overlay.dart';

class ConfirmedOpportunityList extends StatefulWidget {
  const ConfirmedOpportunityList({super.key});

  @override
  State<ConfirmedOpportunityList> createState() => _ConfirmedOpportunityListState();
}

class _ConfirmedOpportunityListState extends State<ConfirmedOpportunityList> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: loading,
      child: Scaffold(
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

              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: ListView.builder(
                  itemCount: opportunities.length,
                  itemBuilder: (context, index) {
                    Opportunity opportunity = opportunities[index];

                    return ConfirmedOpportunityCard(
                      opportunity: opportunity,
                      onLaunch: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MakeDemandPage(
                                opportunity: opportunity),
                          ),
                        );
                      },
                    );
                  },
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
