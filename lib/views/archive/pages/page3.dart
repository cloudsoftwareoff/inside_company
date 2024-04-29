import 'package:flutter/material.dart';
import 'package:inside_company/providers/project_provider.dart';
import 'package:inside_company/utils/format_date_to_string.dart';
import 'package:inside_company/utils/pick_date.dart';
import 'package:provider/provider.dart';

class Page3 extends StatefulWidget {
  const Page3({super.key});

  @override
  State<Page3> createState() => _Page3State();
}
// this.dateAffectation (assignment date)
// this.dateLivraisonPrevue (expected delivery date)
// this.dateLivraisonReelle (actual delivery date)

// this.coutTotalMateriel (total material cost)
// this.coutParArticle (cost per item)
class _Page3State extends State<Page3> {
  final TextEditingController _datePrevuController = TextEditingController();
  final TextEditingController _dateReelleController = TextEditingController();
  final TextEditingController _dateAffectationController =
      TextEditingController();
  final TextEditingController _coutTotalMaterielController =
      TextEditingController();
  final TextEditingController _coutParArticleController =
      TextEditingController();

  bool loaded = true;
  @override
  Widget build(BuildContext context) {
    final projectProvider = Provider.of<ProjectProvider>(context);
    if (loaded) {
     
      if (projectProvider.project!.dateLivraisonPrevue != null) {
        _datePrevuController.text =
            dateTextFormat(projectProvider.project!.dateLivraisonPrevue!);
      }
      if (projectProvider.project!.dateLivraisonReelle != null) {
        _dateReelleController.text =
            dateTextFormat(projectProvider.project!.dateLivraisonReelle!);
      }
      if (projectProvider.project!.dateAffectation != null) {
        _dateAffectationController.text =
            dateTextFormat(projectProvider.project!.dateAffectation!);
      }
      if (projectProvider.project!.coutParArticle != null) {
        _coutParArticleController.text =
            projectProvider.project!.coutParArticle!.toString();
      }
      if (projectProvider.project!.coutTotalMateriel != null) {
        _coutTotalMaterielController.text =
            projectProvider.project!.coutTotalMateriel!.toString();
      }
      loaded = false;
    }
    return Padding(
      padding:const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _datePrevuController,
            decoration: const InputDecoration(
              labelText: 'Date Prévue Livraison',
              border: OutlineInputBorder(),
            ),
            readOnly: true,
            onTap: () async {
              DateTime? picked = await pickDate(context);
              if (picked != null) {
                _datePrevuController.text =
                    "${picked.day}/${picked.month}/${picked.year}";
                projectProvider.project!.dateLivraisonPrevue = picked;
              }
            },
          ),
          SizedBox(height: 20),
          TextField(
            controller: _dateReelleController,
            decoration: const InputDecoration(
              labelText: 'Date Réelle Livraison',
              border: const OutlineInputBorder(),
            ),
            readOnly: true,
            onTap: () async {
              DateTime? picked = await pickDate(context);
              if (picked != null) {
                _dateReelleController.text =
                    "${picked.day}/${picked.month}/${picked.year}";
                projectProvider.project!.dateLivraisonReelle = picked;
              }
            },
          ),
          SizedBox(height: 20),
          TextField(
            controller: _dateAffectationController,
            decoration: const InputDecoration(
              labelText: 'Date Affectation',
              border: OutlineInputBorder(),
            ),
            readOnly: true,
            onTap: () async {
              DateTime? picked = await pickDate(context);
              if (picked != null) {
                _dateAffectationController.text =
                    "${picked.day}/${picked.month}/${picked.year}";
                projectProvider.project!.dateAffectation = picked;
              }
            },
          ),
          SizedBox(height: 20),
          TextField(
            controller: _coutTotalMaterielController,
            decoration: const InputDecoration(
              labelText: 'cout Total Materiel',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              if (value.isNotEmpty) {
                try {
                  projectProvider.project!.coutTotalMateriel =
                      double.parse(value);
                } catch (e) {}
              }
            },
          ),
          //coutParArticle
          SizedBox(height: 20),
          TextField(
            controller: _coutParArticleController,
            decoration: const InputDecoration(
              labelText: 'cout Par Article',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              if (value.isNotEmpty) {
                try {
                  projectProvider.project!.coutParArticle = double.parse(value);
                } catch (e) {}
              } else {
                _coutParArticleController.text = "";
                projectProvider.project!.coutParArticle = null;
              }
            },
          ),
        ],
      ),
    );
  }
}
