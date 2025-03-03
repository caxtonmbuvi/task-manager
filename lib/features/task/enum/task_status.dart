import 'package:freezed_annotation/freezed_annotation.dart';

enum TaskStatus {
  @JsonValue("pending")
  pending,
  @JsonValue("inprogress")
  inprogress,
  @JsonValue("completed")
  completed,
}