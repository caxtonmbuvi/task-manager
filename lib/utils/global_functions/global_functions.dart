import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/utils/enums/task_category.dart';
import 'package:task_manager/utils/enums/task_status.dart';
import 'package:uuid/uuid.dart';

class GlobalFunctions {
  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT, // Duration: LENGTH_SHORT or LENGTH_LONG.
      gravity: ToastGravity.BOTTOM, // Position: BOTTOM, CENTER, TOP.
      backgroundColor: Colors.black, // Background color of the toast.
      textColor: Colors.white, // Text color.
      fontSize: 16, // Text size.
    );
  }

  String getAvatarText(String fullName) {
    if (fullName.trim().isEmpty) return '';
    final trimmedName = fullName.trim();
    // If the name is less than 2 characters, return the entire name in uppercase.
    if (trimmedName.length < 2) return trimmedName.toUpperCase();
    return trimmedName.substring(0, 2).toUpperCase();
  }

  /// Returns a color based on task status.
  Color getStatusColor(TaskStatus status) {
    switch (status) {
      case TaskStatus.inProgress:
        return Colors.green.shade100;
      case TaskStatus.completed:
        return Colors.blue.shade100;
      case TaskStatus.pending:
        return Colors.grey.shade200;
    }
  }

  String getTaskCategoryDisplay(TaskCategory category) {
    switch (category) {
      case TaskCategory.work:
        return "Work 💼";
      case TaskCategory.personal:
        return "Personal 🏡";
      case TaskCategory.other:
        return "Other 🔖";
    }
  }

  String formatDate(String inputDateTime) {
    try {
      final dateTime = DateTime.parse(inputDateTime);

      return DateFormat('dd MMM, yyyy').format(dateTime);
    } catch (e) {
      return 'Invalid date format';
    }
  }

  String formatTime(String inputDateTime) {
    try {
      final dateTime = DateTime.parse(inputDateTime);

      return DateFormat('hh:mm a').format(dateTime);
    } catch (e) {
      return 'Invalid date format';
    }
  }

  String formatReadableDate(String isoDate) {
    try {
      // Parse the ISO string into a DateTime object.
      final dateTime = DateTime.parse(isoDate);

      // Format the date and time.
      final formattedDate = DateFormat('MMM d, yyyy').format(dateTime);
      final formattedTime = DateFormat('hh:mm a').format(dateTime);

      return '$formattedDate at $formattedTime';
    } catch (e) {
      // Handle invalid date formats.
      return 'Invalid date';
    }
  }

  String convertDateString(String inputDate) {
    // Normalize inputDate into a DateTime.
    final dateTime = parseDateString(inputDate);

    // Convert to ISO 8601 while preserving the original hour and minute.
    final dateTimeUtc = DateTime.utc(
      dateTime.year,
      dateTime.month,
      dateTime.day,
      dateTime.hour,
      dateTime.minute,
      dateTime.second,
    );

    return dateTimeUtc.toIso8601String();
  }

  DateTime parseDateString(String dateString) {
    // Attempt ISO 8601 parse first.
    try {
      return DateTime.parse(dateString);
    } catch (_) {
      // Ignore and try another format.
    }

    // Attempt 'dd MMM yyyy' parse.
    try {
      final inputFormat = DateFormat('dd MMM yyyy');
      return inputFormat.parseStrict(dateString);
    } catch (_) {
      // All attempts failed.
    }

    // If we reach here, none of the formats worked.
    throw FormatException('Unsupported date format: "$dateString"');
  }

  String generateId() {
    final uuid = Uuid();
    final String id = uuid.v4();

    return id;
  }

  String getGreeting(DateTime dateTime) {
    final hour = dateTime.hour;
    if (hour < 12) {
      return 'Good Morning 🤗';
    } else if (hour < 18) {
      return 'Good Afternoon ☀️';
    } else {
      return 'Good Evening 🌙';
    }
  }
}
