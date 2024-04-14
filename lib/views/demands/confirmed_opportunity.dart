import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:inside_company/constant.dart';
import 'package:inside_company/model/opportunity.dart';
import 'package:inside_company/services/firestore/opportunitydb.dart';
import 'package:inside_company/views/demands/details.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ConfirmedOpportunity extends StatefulWidget {
  const ConfirmedOpportunity({super.key});

  @override
  State<ConfirmedOpportunity> createState() => _ConfirmedOpportunityState();
}

class _ConfirmedOpportunityState extends State<ConfirmedOpportunity> {
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
      ),
    );
  }
}

Future<void> requestStoragePermissions() async {
  PermissionStatus status = await Permission.storage.request();

  if (status.isGranted) {
    //  permission granted
  } else {
    // Permission denied
    await requestStoragePermissions();
  }
}

Future<void> downloadFile(Opportunity op, BuildContext context) async {
  String? path = op.letter_link;
  if (path == null) {
    print('Error: No file path provided');
    return;
  }

  List<String> parts = path.split('/');
  String fileName = parts.isNotEmpty ? parts.last : '';
  if (fileName.isEmpty) {
    print('Error: Invalid file name');
    return;
  }

  try {
    await requestStoragePermissions();

    final res =
        Supabase.instance.client.storage.from('inside').getPublicUrl(fileName);

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Downloading...")));
    FileDownloader.downloadFile(
        url: res,
        name: fileName, //(optional)

        onDownloadCompleted: (String path) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("Downloaded!")));
        },
        onDownloadError: (String error) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("error : $error")));
        });
  } catch (e) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("error : $e")));
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
        leading: GestureDetector(
          onTap: () async {
            await downloadFile(opportunity, context);
          },
          child: Icon(
            Icons.downhill_skiing,
            color: AppColors.secondaryColor,
          ),
        ),
      ),
    );
  }
}
