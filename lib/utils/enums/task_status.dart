enum TaskStatus {
  pending,
  inProgress,
  completed;

  /// Converts the enum to its string representation.
  String toReadableString() {
    switch (this) {
      case TaskStatus.pending:
        return 'PENDING';
      case TaskStatus.inProgress:
        return 'IN_PROGRESS';
      case TaskStatus.completed:
        return 'COMPLETED';
    }
  }

  /// Parses a string back to the enum.
  static TaskStatus fromString(String value) {
    switch (value.toUpperCase()) {
      case 'PENDING':
        return TaskStatus.pending;
      case 'IN_PROGRESS':
        return TaskStatus.inProgress;
      case 'COMPLETED':
        return TaskStatus.completed;
      default:
        throw ArgumentError('Unknown TaskStatus value: $value');
    }
  }
}
