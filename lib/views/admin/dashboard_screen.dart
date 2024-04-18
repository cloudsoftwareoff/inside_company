import 'package:flutter/material.dart';
import 'package:inside_company/model/demand.dart';
import 'package:inside_company/model/opportunity.dart';
import 'package:inside_company/model/region.dart';
import 'package:inside_company/services/firestore/demand_db.dart';
import 'package:inside_company/services/firestore/opportunitydb.dart';
import 'package:inside_company/services/firestore/regiondb.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final DemandDB _demandDB = DemandDB();
  final OpportunityDB _opportunityDB = OpportunityDB();
  final RegionDB _regionDB = RegionDB();

  List<Opportunity> _opportunities = [];
  List<Demand> _demands = [];
  Map<String, Region> _regions = {};

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final opportunities = await _opportunityDB.fetchOpportunities();
    final demands = await _demandDB.getDemands();
    final regions = await _regionDB.fetchRegion();

    final regionMap = {for (var region in regions!) region.id: region};

    setState(() {
      _opportunities = opportunities;
      _demands = demands;
      _regions = regionMap;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: _opportunities.length,
        itemBuilder: (context, index) {
          final opportunity = _opportunities[index];
          final region = _regions[opportunity.region];
          final associatedDemands = _demands
              .where((demand) => demand.opportunityId == opportunity.id)
              .toList();

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: ListTile(
                title: Text(opportunity.title),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Description: ${opportunity.description}'),
                    Text('Region: ${region?.name ?? 'Unknown'}'),
                    Text('Budget: ${opportunity.budget}'),
                    Text('Status: ${opportunity.status}'),
                    const Text(
                      'Associated Demands:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: associatedDemands
                          .map((demand) =>
                              Text('${demand.id}: Budget${demand.budget}'))
                          .toList(),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
