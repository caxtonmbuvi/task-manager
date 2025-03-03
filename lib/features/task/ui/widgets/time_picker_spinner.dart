// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class TimePickerSpinner extends StatelessWidget {
  const TimePickerSpinner({
    super.key,
    required this.selectedTime,
    required this.onTimeChanged,
  });
  final TimeOfDay selectedTime;
  final Function(TimeOfDay) onTimeChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildWheel(
          List.generate(12, (index) => index == 0 ? 12 : index),
          selectedTime.hourOfPeriod,
          'Hour',
          (hour) {
            final value = hour as int;
            final newHour = selectedTime.period == DayPeriod.pm
                ? (value % 12) + 12
                : value % 12;
            onTimeChanged(
              TimeOfDay(hour: newHour, minute: selectedTime.minute),
            );
          },
        ),
        _buildWheel(
          List.generate(60, (index) => index),
          selectedTime.minute,
          'Min',
          (minute) {
            onTimeChanged(
              TimeOfDay(hour: selectedTime.hour, minute: minute as int),
            );
          },
        ),
        _buildWheel(
          ['AM', 'PM'],
          selectedTime.period == DayPeriod.am ? 'AM' : 'PM',
          'Period',
          (period) {
            final isPM = period == 'PM';
            final newHour = isPM
                ? (selectedTime.hourOfPeriod % 12) + 12
                : selectedTime.hourOfPeriod % 12;
            onTimeChanged(
              TimeOfDay(hour: newHour, minute: selectedTime.minute),
            );
          },
        ),
      ],
    );
  }

  Widget _buildWheel(
    List<dynamic> items,
    dynamic selectedValue,
    String label,
    Function(dynamic) onChanged,
  ) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 14)),
        const SizedBox(height: 5),
        SizedBox(
          height: 120,
          width: 60,
          child: ListWheelScrollView.useDelegate(
            itemExtent: 40,
            physics: const FixedExtentScrollPhysics(),
            perspective: 0.01,
            onSelectedItemChanged: (index) => onChanged(items[index]),
            childDelegate: ListWheelChildBuilderDelegate(
              builder: (context, index) {
                final isSelected = items[index] == selectedValue;
                return Center(
                  child: Text(
                    items[index].toString(),
                    style: TextStyle(
                      fontSize: isSelected ? 20 : 16,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.w400,
                    ),
                  ),
                );
              },
              childCount: items.length,
            ),
          ),
        ),
      ],
    );
  }
}
