import 'package:flutter/material.dart';
import 'package:inside_company/providers/project_provider.dart';
import 'package:provider/provider.dart';

class Page1 extends StatefulWidget {
  @override
  _Page1State createState() => _Page1State();
}

class _Page1State extends State<Page1> {
  DateTime _echeance = DateTime.now();

  final TextEditingController _budget = TextEditingController();
  final TextEditingController _name = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    _budget.dispose();
    _name.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final projectProvider = Provider.of<ProjectProvider>(context);
    if (projectProvider.project!.budgetAlloue != null) {
      var budgetValue = projectProvider.project!.budgetAlloue!;

      if (budgetValue % 1 == 0) {
        _budget.text = budgetValue.toInt().toString();
      } else {
        _budget.text = budgetValue.toString();
      }
    }

    if (projectProvider.project!.echeance != null) {
      _echeance = projectProvider.project!.echeance!;
    }

    _name.text = projectProvider.project!.name;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _name,
            decoration: const InputDecoration(
              labelText: 'Project Name',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              projectProvider.project!.name = value;
            },
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _budget,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: 'Budget Alloué',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              try {
                if (value.length > 0) {
                  projectProvider.project!.budgetAlloue = double.parse(value);
                } else {
                  projectProvider.project!.budgetAlloue = 0;
                }
              } catch (e) {}
            },
          ),
          const SizedBox(height: 20),
          buildDateTextField(
            labelText: 'Date de echeance',
            selectedDate: _echeance,
            onTap: () => _selectDate(context, _echeance, (pickedDate) {
              setState(() {
                _echeance = pickedDate;
                projectProvider.project!.echeance = pickedDate;
              });
            }),
          ),
          const SizedBox(height: 20),
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
        border: const OutlineInputBorder(),
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
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != initialDate) {
      onDateSelected(picked);
    }
  }
}
