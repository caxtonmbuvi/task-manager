import 'package:flutter_bloc/flutter_bloc.dart';

class MeetingCubit extends Cubit<bool> {
  MeetingCubit() : super(false);

  void toggle() => emit(!state);
}
