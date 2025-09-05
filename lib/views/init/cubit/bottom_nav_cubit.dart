import 'package:chatty_ai/views/init/cubit/bottom_nav_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BottomNavCubit extends Cubit<BottomNavState> {
  BottomNavCubit() : super(BottomNavState(currentIndex: 0));

  void changeTab(int index) {
    emit(state.copyWith(currentIndex: index));
  }
}
