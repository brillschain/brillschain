import 'package:flutter/material.dart';

class DatePickerButton extends StatefulWidget {
  const DatePickerButton({super.key});

  @override
  State<DatePickerButton> createState() => _DatePickerButtonState();
}

class _DatePickerButtonState extends State<DatePickerButton> {
  final TextEditingController _dateController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      setState(() {
        _dateController.text =
            "${picked.toLocal()}".split(' ')[0]; // Format date if needed
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextFormField(
        controller: _dateController,
        decoration: InputDecoration(
          labelText: 'Date of Connection',
          suffixIcon: const Icon(
            Icons.arrow_drop_down,
            color: Colors.blue,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        readOnly: true, // Prevent manual input
        onTap: () => _selectDate(context),
      ),
    );
  }
}
