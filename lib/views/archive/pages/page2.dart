
import 'package:flutter/material.dart';
import 'package:inside_company/providers/project_provider.dart';
import 'package:provider/provider.dart';

class Page2 extends StatefulWidget {
  const Page2({super.key});

  @override
  _Page2State createState() => _Page2State();
}

class _Page2State extends State<Page2> {
  DateTime? _dateClotureAO;
  DateTime? _dateOuvertureOffres;
   
  @override
  Widget build(BuildContext context) {
 final project =
        Provider.of<ProjectProvider>(context).project;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TextField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Délai AO',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            decoration: const InputDecoration(
              labelText: 'Date Clôture AO',
              border: OutlineInputBorder(),
            ),
            readOnly: true,
            controller: TextEditingController(
              text: _dateClotureAO != null
                  ? "${_dateClotureAO!.day}/${_dateClotureAO!.month}/${_dateClotureAO!.year}"
                  : '',
            ),
            onTap: () {
              _selectDateClotureAO(context);
            },
          ),
          const SizedBox(height: 20),
          TextField(
            decoration: const InputDecoration(
              labelText: 'Date Ouverture Offres',
              border: OutlineInputBorder(),
            ),
            readOnly: true,
            controller: TextEditingController(
              text: _dateOuvertureOffres != null
                  ? "${_dateOuvertureOffres!.day}/${_dateOuvertureOffres!.month}/${_dateOuvertureOffres!.year}"
                  : '',
            ),
            onTap: () {
              _selectDateOuvertureOffres(context);
            },
          ),
        ],
      ),
    );
  }

  Future<void> _selectDateClotureAO(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dateClotureAO ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _dateClotureAO) {
      setState(() {
        _dateClotureAO = picked;
      });
    }
  }

  Future<void> _selectDateOuvertureOffres(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dateOuvertureOffres ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _dateOuvertureOffres) {
      setState(() {
        _dateOuvertureOffres = picked;
      });
    }
  }
}

