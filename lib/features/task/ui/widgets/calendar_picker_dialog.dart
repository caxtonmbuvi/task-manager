import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class CalendarPickerDialog extends StatelessWidget {
  const CalendarPickerDialog({
    super.key,
    required this.startDate,
    required this.endDate,
    required this.busyTimes,
    this.minSelectableDateOverride,
  });

  final DateTime startDate;
  final DateTime endDate;
  final List<DateTimeRange> busyTimes;
  final DateTime? minSelectableDateOverride; // Nullable override parameter.

  @override
  Widget build(BuildContext context) {
    // Strip time from start, push time to end-of-day for endDate.
    final startOfDay = DateTime(startDate.year, startDate.month, startDate.day);
    final endOfDay =
        DateTime(endDate.year, endDate.month, endDate.day, 23, 59, 59);

    // If no override provided, use default logic:
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final defaultMinDate = (startOfDay.isAfter(todayStart))
        ? startOfDay
        : todayStart;

    // Use the override if provided, otherwise default.
    final effectiveMinDate = minSelectableDateOverride ?? defaultMinDate;

    return Dialog(
      insetPadding: const EdgeInsets.all(20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            SizedBox(
              height: 400,
              width: 350,
              child: SfDateRangePicker(
                minDate: effectiveMinDate,
                maxDate: endOfDay,
                // selectableDayPredicate: selectableDayPredicate,
                onSelectionChanged:
                    (DateRangePickerSelectionChangedArgs args) =>
                        onSelectionChanged(context, args),
                selectionColor: Colors.blue,
                todayHighlightColor: Colors.blue,
                headerStyle: DateRangePickerHeaderStyle(
                  textAlign: TextAlign.center,
                  backgroundColor: Colors.transparent,
                  textStyle: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue[800],
                  ),
                ),
                monthCellStyle: DateRangePickerMonthCellStyle(
                  textStyle: TextStyle(color: Colors.grey[800]),
                  todayTextStyle: const TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                  disabledDatesTextStyle: TextStyle(color: Colors.grey[400]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool selectableDayPredicate(DateTime date) {
    return !busyTimes.any(
      (range) =>
          date.isAfter(range.start.subtract(const Duration(days: 1))) &&
          date.isBefore(range.end.add(const Duration(days: 1))),
    );
  }

  void onSelectionChanged(
    BuildContext context,
    DateRangePickerSelectionChangedArgs args,
  ) {
    if (args.value is DateTime) {
      Navigator.pop(context, args.value);
    }
  }
}
