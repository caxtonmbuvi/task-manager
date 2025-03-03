import 'package:flutter_bloc/flutter_bloc.dart';

class TermsCubit extends Cubit<bool> {
  TermsCubit() : super(false);

  void toggle() => emit(!state);
}
