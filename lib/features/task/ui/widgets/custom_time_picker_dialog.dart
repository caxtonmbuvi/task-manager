
import 'package:flutter/material.dart';
import 'package:task_manager/features/task/ui/widgets/time_picker_spinner.dart';
import 'package:task_manager/utils/widgets/custom_button.dart';

class CustomTimePickerDialog extends StatefulWidget {
  const CustomTimePickerDialog({super.key, this.initialTime});
  final TimeOfDay? initialTime;

  @override
  TimePickerDialogState createState() => TimePickerDialogState();
}

class TimePickerDialogState extends State<CustomTimePickerDialog> {
  late TimeOfDay _selectedTime;

  @override
  void initState() {
    super.initState();
    _selectedTime = widget.initialTime ?? TimeOfDay.now();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Select Time',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
              child: TimePickerSpinner(
                selectedTime: _selectedTime,
                onTimeChanged: onTimeChanged,
              ),
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: 'confirm',
              onTap: () => Navigator.pop(context, _selectedTime),
            ),
          ],
        ),
      ),
    );
  }

  void onTimeChanged(
    TimeOfDay newTime,
  ) {
    setState(() {
      _selectedTime = newTime;
    });
  }
}
