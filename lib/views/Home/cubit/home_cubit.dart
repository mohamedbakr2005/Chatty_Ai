import 'package:chatty_ai/core/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeInitial());

  void showWelcome() {
    emit(const HomeWelcome());
  }

  void showChat() {
    emit(const HomeChat());
  }

  void showLoading() {
    emit(const HomeLoading());
  }

  void showError(String message) {
    emit(HomeError(message));
  }

  void reset() {
    emit(const HomeInitial());
  }
}
