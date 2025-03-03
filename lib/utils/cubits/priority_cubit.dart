import 'package:flutter_bloc/flutter_bloc.dart';

class PriorityCubit extends Cubit<bool> {
  PriorityCubit() : super(false);

  void toggle() => emit(!state);
}
