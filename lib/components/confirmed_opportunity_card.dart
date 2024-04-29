import 'package:flutter/material.dart';
import 'package:inside_company/constant.dart';
import 'package:inside_company/model/opportunity.dart';
import 'package:inside_company/utils/download_file.dart';

class ConfirmedOpportunityCard extends StatelessWidget {
  final Opportunity opportunity;
  final VoidCallback onLaunch;
  const ConfirmedOpportunityCard(
      {Key? key, required this.opportunity, required this.onLaunch})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 4,
      child: ListTile(
        tileColor: Colors.white,
        title: Text(
          opportunity.title,
          style: TextStyle(
              fontWeight: FontWeight.bold, color: AppColors.primaryColor),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(
              opportunity.description,
              maxLines: 1,
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Text(
                  "Budget: ",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                Text(
                  " ${opportunity.budget.toStringAsFixed(2)} TND",
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              "Materials: ${opportunity.material.join(', ')}",
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
        trailing: const Icon(Icons.launch),
        onTap: () {
          onLaunch();
        },
        leading: GestureDetector(
          onTap: () async {
            await downloadFile(opportunity, context);
          },
          child: const Icon(
            Icons.download,
            color: Colors.blueAccent,
          ),
        ),
      ),
    );
  }
}
