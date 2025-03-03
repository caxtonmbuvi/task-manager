import 'package:freezed_annotation/freezed_annotation.dart';

enum TaskCategory {
  @JsonValue("work")
  work,
  @JsonValue("personal")
  personal,
  @JsonValue("other")
  other,
}
