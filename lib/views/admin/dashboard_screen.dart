import 'package:flutter/material.dart';
import 'package:inside_company/constant.dart';
import 'package:inside_company/model/demand.dart';
import 'package:inside_company/model/opportunity.dart';
import 'package:inside_company/model/region.dart';
import 'package:inside_company/model/user_model.dart';
import 'package:inside_company/providers/users_list.dart';
import 'package:inside_company/services/firestore/demand_db.dart';
import 'package:inside_company/services/firestore/opportunitydb.dart';
import 'package:inside_company/services/firestore/regiondb.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

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
  List<Region> _regions = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final opportunities = await _opportunityDB.fetchOpportunities();
    final demands = await _demandDB.getDemands();
    final regions = await _regionDB.fetchRegion();

    setState(() {
      _opportunities = opportunities;
      _demands = demands;
      _regions = regions!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: _opportunities.length,
        itemBuilder: (context, index) {
          final opportunity = _opportunities[index];
          final region = _regions
              .firstWhere((element) => element.id == opportunity.region);
          final associatedDemands = _demands
              .where((demand) => demand.opportunityId == opportunity.id)
              .toList();

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: ListTile(
                title: RichText(
                  textScaler: MediaQuery.of(context).textScaler,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "${region.name}: ",
                        style: TextStyle(
                            fontFamily: 'Outfit',
                            color: AppColors.primaryColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: opportunity.title,
                        style: TextStyle(
                            fontFamily: 'Outfit',
                            color: AppColors.secondaryColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CardTask(opportunity: opportunity),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: associatedDemands
                          .map((demand) => DemandCard(demand: demand))
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

class CardTask extends StatelessWidget {
  final Opportunity opportunity;

  const CardTask({super.key, required this.opportunity});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserListProvider>(context);
    List<UserModel> users = userProvider.users;
    print(users.length);
    if (users.isNotEmpty) {
      print(users);
    }

    UserModel user = users.first;
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: const Color(0x4D9489F5),
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFF6F61EF),
                  width: 2,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(2),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: Image.network(
                    user.picture,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                child: Text(
                  user.username,
                  style: const TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    color: Color(0xFF15161E),
                    fontSize: 14,
                    letterSpacing: 0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Text(
              DateFormat('MMM dd, yyyy - HH:mm')
                  .format(opportunity.timestamp!.toDate()),
              style: const TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                color: Color(0xFF606A85),
                fontSize: 12,
                letterSpacing: 0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(18, 0, 0, 0),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: const [
                BoxShadow(
                  blurRadius: 0,
                  color: Color(0xFF6F61EF),
                  offset: Offset(
                    -2,
                    0,
                  ),
                )
              ],
              border: Border.all(
                color: Colors.white,
                width: 1,
              ),
            ),
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(26, 0, 0, 0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 4),
                    child: RichText(
                      textScaler: MediaQuery.of(context).textScaler,
                      text: TextSpan(
                        children: [
                          const TextSpan(
                            text: 'State:',
                            style: TextStyle(),
                          ),
                          TextSpan(
                            text: opportunity.status.toLowerCase(),
                            style: const TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              color: Color(0xFF6F61EF),
                              fontSize: 14,
                              letterSpacing: 0,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                        style: const TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          color: Color(0xFF606A85),
                          fontSize: 14,
                          letterSpacing: 0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 12),
                    child: Text(
                      opportunity.description,
                      style: const TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        color: Color(0xFF606A85),
                        fontSize: 12,
                        letterSpacing: 0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: opportunity.material.map((material) {
                      return Chip(
                        label: Text(material),
                      );
                    }).toList(),
                  ),
                  const Divider(
                    height: 1,
                    thickness: 1,
                    indent: 0,
                    color: Color(0xFFE5E7EB),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class DemandCard extends StatelessWidget {
  final Demand demand;

  const DemandCard({super.key, required this.demand});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserListProvider>(context);
    List<UserModel> users = userProvider.users;
    print(users.length);
    if (users.isNotEmpty) {
      print(users);
    }
    UserModel user = users[1];
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color:const Color(0x4D9489F5),
                shape: BoxShape.circle,
                border: Border.all(
                  color:const Color(0xFF6F61EF),
                  width: 2,
                ),
              ),
              child: Padding(
                padding:const EdgeInsets.all(2),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: Image.network(
                    user.picture,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                child: Text(
                  user.username,
                  style: const TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    color: Color(0xFF15161E),
                    fontSize: 14,
                    letterSpacing: 0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Text(
              DateFormat('MMM dd, yyyy - HH:mm').format(demand.dateDA.toDate()),
              style: const TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                color: Color(0xFF606A85),
                fontSize: 12,
                letterSpacing: 0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(18, 0, 0, 0),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: const [
                BoxShadow(
                  blurRadius: 0,
                  color: Color(0xFF6F61EF),
                  offset: Offset(
                    -2,
                    0,
                  ),
                )
              ],
              border: Border.all(
                color: Colors.white,
                width: 1,
              ),
            ),
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(26, 0, 0, 0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 4),
                    child: RichText(
                      textScaler: MediaQuery.of(context).textScaler,
                      text: TextSpan(
                        children: [
                          const TextSpan(
                            text: 'Budget:',
                            style: TextStyle(),
                          ),
                          TextSpan(
                            text: demand.budget.toString(),
                            style: const TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              color: Color(0xFF6F61EF),
                              fontSize: 14,
                              letterSpacing: 0,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                        style: const TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          color: Color(0xFF606A85),
                          fontSize: 14,
                          letterSpacing: 0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: demand.materials.map((material) {
                      return Chip(
                        label: Text(material),
                      );
                    }).toList(),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 12),
                    child: Text(
                      demand.state,
                      style: const TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        color: Color(0xFF606A85),
                        fontSize: 12,
                        letterSpacing: 0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const Divider(
                    height: 1,
                    thickness: 1,
                    indent: 0,
                    color: Color(0xFFE5E7EB),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
