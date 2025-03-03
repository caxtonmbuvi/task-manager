enum TaskPriority {
  low,
  high;

  String toReadableString() {
    switch (this) {
      case TaskPriority.low:
        return 'LOW';
      case TaskPriority.high:
        return 'HIGH';
    }
  }

  static TaskPriority fromString(String value) {
    switch (value.toUpperCase()) {
      case 'LOW':
        return TaskPriority.low;
      case 'HIGH':
        return TaskPriority.high;

      default:
        throw ArgumentError('Unknown TaskStatus value: $value');
    }
  }
}
