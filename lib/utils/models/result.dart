import 'package:freezed_annotation/freezed_annotation.dart';

part 'result.freezed.dart';

@freezed
class Result<T> with _$Result<T> {
  const Result._();
  const factory Result.empty() = _Empty<T>;
  const factory Result.loading({T? oldResult}) = _Loading<T>;
  const factory Result.success(T result) = _Success<T>;
  const factory Result.failure(
    String message, {
    dynamic error,
    StackTrace? stack,
  }) = _Failure<T>;

  

  bool get failed => maybeMap(
        failure: (_) => true,
        orElse: () => false,
      );

  bool get succeeded => maybeMap(
        success: (_) => true,
        orElse: () => false,
      );

  bool get isLoading => maybeMap(
        loading: (_) => true,
        orElse: () => false,
      );

  String? get failureMessage => maybeMap(
        failure: (f) => f.message,
        orElse: () => null,
      );
}
