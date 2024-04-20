import 'package:flutter/material.dart';
import 'package:inside_company/providers/project_provider.dart';
import 'package:provider/provider.dart';

class Page1 extends StatefulWidget {
  @override
  _Page1State createState() => _Page1State();
}

class _Page1State extends State<Page1> {
  DateTime _dateMiseEnVigueur = DateTime.now();
  DateTime _datePublicationAO = DateTime.now();
  final TextEditingController _budget = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    _budget.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final projectProvider = Provider.of<ProjectProvider>(context);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _budget,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: 'Budget Alloué',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              projectProvider.project!.budgetAlloue = double.parse(value);
            },
          ),
          SizedBox(height: 20),
          buildDateTextField(
            labelText: 'Date de Mise en Vigueur',
            selectedDate: _dateMiseEnVigueur,
            onTap: () => _selectDate(context, _dateMiseEnVigueur, (pickedDate) {
              setState(() {
                _dateMiseEnVigueur = pickedDate;
                projectProvider.project!.dateMiseEnVigueur = pickedDate;
              });
            }),
          ),
          SizedBox(height: 20),
          buildDateTextField(
            labelText: 'Date de Publication AO',
            selectedDate: _datePublicationAO,
            onTap: () => _selectDate(context, _datePublicationAO, (pickedDate) {
              setState(() {
                _datePublicationAO = pickedDate;
                projectProvider.project!.datePublicationAO = pickedDate;
              });
            }),
          ),
        ],
      ),
    );
  }

  Widget buildDateTextField({
    String? labelText,
    DateTime? selectedDate,
    VoidCallback? onTap,
  }) {
    return TextField(
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(),
      ),
      readOnly: true,
      controller: TextEditingController(
        text: selectedDate != null
            ? "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}"
            : '',
      ),
      onTap: onTap,
    );
  }

  Future<void> _selectDate(BuildContext context, DateTime initialDate,
      Function(DateTime) onDateSelected) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != initialDate) {
      onDateSelected(picked);
    }
  }
}
