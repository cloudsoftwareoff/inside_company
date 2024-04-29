import 'package:flutter/material.dart';
import 'package:inside_company/providers/project_provider.dart';
import 'package:inside_company/utils/format_date_to_string.dart';
import 'package:inside_company/utils/pick_date.dart';
import 'package:provider/provider.dart';

class Page2 extends StatefulWidget {
  const Page2({super.key});

  @override
  _Page2State createState() => _Page2State();
}

class _Page2State extends State<Page2> {
  final TextEditingController _datePreparationCahierChargesController =
      TextEditingController();
  final TextEditingController _dateValidationCahierChargesController =
      TextEditingController();
  final TextEditingController _datePublicationAppelOffreController =
      TextEditingController();
  final TextEditingController _dateClotureAppelOffreController =
      TextEditingController();
  final TextEditingController _fournisseurController = TextEditingController();

// this.datePreparationCahierCharges (date of preparing specifications)
// this.dateValidationCahierCharges (date of approving specifications)
// this.datePublicationAppelOffre (date of publishing call for offers)
// this.dateClotureAppelOffre (closing date for offers)

// this.fournisseur (supplier)
  @override
  Widget build(BuildContext context) {
    final projectProvider = Provider.of<ProjectProvider>(context);
    if (projectProvider.project!.datePreparationCahierCharges != null) {
      _datePreparationCahierChargesController.text = dateTextFormat(
          projectProvider.project!.datePreparationCahierCharges!);
    }
    if (projectProvider.project!.dateValidationCahierCharges != null) {
      _dateValidationCahierChargesController.text =
          dateTextFormat(projectProvider.project!.dateValidationCahierCharges!);
    }

    if (projectProvider.project!.datePublicationAppelOffre != null) {
      _datePublicationAppelOffreController.text =
          dateTextFormat(projectProvider.project!.datePublicationAppelOffre!);
    }
    if (projectProvider.project!.dateClotureAppelOffre != null) {
      _dateClotureAppelOffreController.text =
          dateTextFormat(projectProvider.project!.dateClotureAppelOffre!);
    }
    if (projectProvider.project!.fournisseur != null) {
      _fournisseurController.text = projectProvider.project!.fournisseur!;
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            decoration: const InputDecoration(
              labelText: 'date Preparation Cahier de Charges',
              border: OutlineInputBorder(),
            ),
            readOnly: true,
            controller: _datePreparationCahierChargesController,
            onTap: () async {
              DateTime? picked = await pickDate(context);
              if (picked != null) {
                _datePreparationCahierChargesController.text =
                    dateTextFormat(picked);
                projectProvider.project!.datePreparationCahierCharges = picked;
              }
            },
          ),
          //2
          const SizedBox(height: 20),
          TextField(
            decoration: const InputDecoration(
              labelText: 'date Validation CahierCharges',
              border: OutlineInputBorder(),
            ),
            readOnly: true,
            controller: _dateValidationCahierChargesController,
            onTap: () async {
              DateTime? picked = await pickDate(context);
              if (picked != null) {
                _dateValidationCahierChargesController.text =
                    dateTextFormat(picked);
                projectProvider.project!.dateValidationCahierCharges = picked;
              }
            },
          ),
          const SizedBox(height: 20),
          //3
          TextField(
            decoration: const InputDecoration(
              labelText: 'date Publication Appel Offre',
              border: OutlineInputBorder(),
            ),
            readOnly: true,
            controller: _datePublicationAppelOffreController,
            onTap: () async {
              DateTime? picked = await pickDate(context);
              if (picked != null) {
                _datePublicationAppelOffreController.text =
                    dateTextFormat(picked);
                projectProvider.project!.datePublicationAppelOffre = picked;
              }
            },
          ),
          const SizedBox(height: 20),
          //4
          TextField(
            decoration: const InputDecoration(
              labelText: 'date Cloture Appel Offre',
              border: OutlineInputBorder(),
            ),
            readOnly: true,
            controller: _dateClotureAppelOffreController,
            onTap: () async {
              DateTime? picked = await pickDate(context);
              if (picked != null) {
                _dateClotureAppelOffreController.text = dateTextFormat(picked);
                projectProvider.project!.dateClotureAppelOffre = picked;
              }
            },
          ),
          const SizedBox(height: 20),
          //5
          TextField(
            decoration: const InputDecoration(
              labelText: 'Fournisseur',
              border: OutlineInputBorder(),
            ),
            controller: _fournisseurController,
            onChanged: (value) {
              _fournisseurController.text =
                  projectProvider.project!.fournisseur = value;
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
