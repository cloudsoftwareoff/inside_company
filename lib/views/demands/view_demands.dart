import 'package:flutter/material.dart';

import 'package:inside_company/model/demand.dart';
import 'package:inside_company/model/opportunity.dart';

import 'package:inside_company/services/firestore/demand_db.dart';
import 'package:inside_company/services/firestore/opportunitydb.dart';
import 'package:intl/intl.dart';
import 'package:loading_overlay/loading_overlay.dart';

class ViewDemands extends StatefulWidget {
  const ViewDemands({Key? key}) : super(key: key);

  @override
  _ViewDemandsState createState() => _ViewDemandsState();
}

bool _isLoading = false;

class _ViewDemandsState extends State<ViewDemands> {
  late List<Demand> _demands;
  late GlobalKey<AnimatedListState> _listKey;

  @override
  void initState() {
    super.initState();
    _demands = [];
    _listKey = GlobalKey<AnimatedListState>();
    _loadDemands();
  }

  Future<void> _loadDemands() async {
    List<Demand> demands = await DemandDB().getDemands();

    setState(() {
      _demands = demands;
    });
  }

  void _onItemTap(Demand demand, BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Demand"),
          content:
              const Text("Are you sure you want to proceed with this demand?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                try {
                  // Show loading indicator
                  setState(() {
                    _isLoading = true;
                  });

                  // Update demand state to "CONFIRMED"
                  demand.state = "CONFIRMED";
                  await DemandDB().updateDemand(demand);

                  // Show confirmation message
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Demand Confirmed")));

                  // Close the dialog
                  Navigator.of(context).pop();

                  // Hide loading indicator
                  setState(() {
                    _isLoading = false;
                  });

                  print('confirmed');
                } catch (e) {
                  print("Error confirming demand: $e");
                  // Handle error
                  // Hide loading indicator
                  setState(() {
                    _isLoading = false;
                  });
                }
              },
              child: const Text("Confirm"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_demands.isEmpty) {
      return const Center(
        child: Text("No pending Demand at the moment"),
      );
    }
    return Scaffold(
      body: LoadingOverlay(
        isLoading: _isLoading,
        child: FutureBuilder<List<Opportunity>>(
          future: OpportunityDB().fetchOpportunities(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No opportunities found.'));
            } else {
              List<Opportunity> opportunities = snapshot.data!;

              return AnimatedList(
                key: _listKey,
                initialItemCount: _demands.length,
                itemBuilder: (context, index, animation) {
                  Opportunity opportunity = opportunities.firstWhere(
                    (element) => element.id == _demands[index].opportunityId,
                  );
                  return _buildItem(_demands[index], animation, opportunity);
                },
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildItem(
      Demand demand, Animation<double> animation, Opportunity opportunity) {
    return SizeTransition(
      sizeFactor: animation,
      child: Card(
        elevation: 8,
        color: Colors.white10,
        child: ListTile(
          title: Text(opportunity.title),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("Budget: ${demand.budget.toString()} TND"),
              Text(DateFormat('MMM dd, yyyy - HH:mm a')
                  .format(opportunity.timestamp!.toDate()))
            ],
          ),
          leading: const Icon(
            Icons.shop_2_rounded,
            color: Colors.amber,
          ),
          trailing: demand.state == "CONFIRMED"
              ? Text("Demand Confirmed")
              : ElevatedButton(
                  onPressed: () {
                    _onItemTap(demand, context);
                  },
                  child: const Text("Confirm")),
        ),
      ),
    );
  }
}
