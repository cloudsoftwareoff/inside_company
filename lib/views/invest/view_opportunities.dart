import 'package:flutter/material.dart';
import 'package:inside_company/model/opportunity.dart';
import 'package:inside_company/services/firestore/opportunitydb.dart';
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
  void initState() {
    super.initState();
    _opportunities = [];
    _listKey = GlobalKey<AnimatedListState>();
    _loadOpportunities();
  }

  Future<void> _loadOpportunities() async {
    List<Opportunity> opportunities =
        await OpportunityDB().fetchPendingOpportunities();
    setState(() {
      _opportunities = opportunities;
    });
  }

  void _onItemTap(Opportunity opportunity) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ConfirmationScreen(opportunity: opportunity),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_opportunities.isEmpty) {
      return const Center(
        child: Text("No pending Opportunity at the moment"),
      );
    }
    return Scaffold(
      body: AnimatedList(
        key: _listKey,
        initialItemCount: _opportunities.length,
        itemBuilder: (context, index, animation) {
          return _buildItem(_opportunities[index], animation, index);
        },
      ),
    );
  }

  Widget _buildItem(
      Opportunity opportunity, Animation<double> animation, int index) {
    return SizeTransition(
      sizeFactor: animation,
      child: Card(
        elevation: 8,
        color: Colors.white10,
        child: ListTile(
          title: Text(opportunity.title),
          subtitle: Text(opportunity.description),
          leading: const Icon(
            Icons.pending,
            color: Colors.amber,
          ),
          trailing: GestureDetector(
            onTap: () => _onItemTap(opportunity),
            child:const Icon(Icons.confirmation_num),
          ),
        ),
      ),
    );
  }
}
