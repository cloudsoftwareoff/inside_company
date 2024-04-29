import 'package:flutter/material.dart';
import 'package:inside_company/providers/project_provider.dart';
import 'package:inside_company/utils/format_date_to_string.dart';
import 'package:inside_company/utils/pick_date.dart';
import 'package:provider/provider.dart';

class Page4 extends StatefulWidget {
  const Page4({super.key});

  @override
  State<Page4> createState() => _Page4State();
}

class _Page4State extends State<Page4> {
  final TextEditingController _dateReceptionDefinitiveController =
      TextEditingController();
  final TextEditingController _penaliteController = TextEditingController();
  final TextEditingController _coefficientPenaliteController =
      TextEditingController();
  final TextEditingController _plafondPenaliteController =
      TextEditingController();
  bool loaded = true;
  // @override
  // void dispose() {
  //   // TODO: implement dispose
  //   super.dispose();
  //   _dateReceptionDefinitiveController.dispose();
  //   _penaliteController.dispose();
  //   _coefficientPenaliteController.dispose();
  //   _plafondPenaliteController.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    final projectProvider = Provider.of<ProjectProvider>(context);
    if (loaded) {
      if (projectProvider.project!.dateReceptionDefinitive != null) {
        _dateReceptionDefinitiveController.text =
            dateTextFormat(projectProvider.project!.dateReceptionDefinitive!);
      }

      if (projectProvider.project!.coefficientPenalite != null) {
        _coefficientPenaliteController.text =
            projectProvider.project!.coefficientPenalite!.toString();
      }
      if (projectProvider.project!.plafondPenalite != null) {
        _plafondPenaliteController.text =
            projectProvider.project!.plafondPenalite!.toStringAsFixed(0);
      }
      loaded = false;
    }
    if (projectProvider.project!.penalite != null) {
      _penaliteController.text = projectProvider.project!.penalite!.toString();
    }
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _dateReceptionDefinitiveController,
            decoration: const InputDecoration(
              labelText: 'date Reception Definitive',
              border: OutlineInputBorder(),
            ),
            readOnly: true,
            onTap: () async {
              DateTime? picked = await pickDate(context);
              if (picked != null) {
                _dateReceptionDefinitiveController.text =
                    "${picked.day}/${picked.month}/${picked.year}";
                projectProvider.project!.dateReceptionDefinitive = picked;
              }
            },
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _coefficientPenaliteController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: 'Coefficient Pénalité',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              if (value.isNotEmpty) {
                try {
                  projectProvider.project!.coefficientPenalite =
                      double.parse(value);
                } catch (e) {}
              } else {
                projectProvider.project!.coefficientPenalite = null;
              }
            },
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _plafondPenaliteController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: 'Plafond Pénalité',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              if (value.isNotEmpty) {
                try {
                  projectProvider.project!.plafondPenalite =
                      double.parse(value);
                } catch (e) {}
              } else {
                projectProvider.project!.plafondPenalite = null;
              }
            },
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _penaliteController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            readOnly: true,
            decoration: const InputDecoration(
              labelText: 'Montant Pénalité',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }
}
