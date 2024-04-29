import 'package:flutter/material.dart';
import 'package:inside_company/components/opportunity_card.dart';
import 'package:inside_company/model/opportunity.dart';
import 'package:inside_company/notification/listener.dart';
import 'package:inside_company/services/firestore/opportunity_db.dart';
import 'package:inside_company/views/invest/confirmation_screen.dart';

class ViewPendingOpportunity extends StatefulWidget {
  const ViewPendingOpportunity({Key? key}) : super(key: key);

  @override
  _ViewPendingOpportunityState createState() => _ViewPendingOpportunityState();
}

class _ViewPendingOpportunityState extends State<ViewPendingOpportunity> {
  late List<Opportunity> _opportunities;
  late GlobalKey<AnimatedListState> _listKey;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _opportunities = [];
    _listKey = GlobalKey<AnimatedListState>();
    _loadOpportunities();
    listenToRealtimeUpdates('invest');
  }

  Future<void> _loadOpportunities() async {
    List<Opportunity> opportunities =
        await OpportunityDB().fetchOpportunitiesByState("PENDING");
    try {
      setState(() {
        _opportunities = opportunities;
      });
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    if (_opportunities.isEmpty) {
      return const Center(
        child: Text("No pending Opportunity at the moment"),
      );
    }
    return Center(
      child: AnimatedList(
        key: _listKey,
        initialItemCount: _opportunities.length,
        itemBuilder: (context, index, animation) {
          return OpportunityColoredCard(
            opportunity: _opportunities[index],
            onClick: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ConfirmOpportunityScreen(
                      opportunity: _opportunities[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
