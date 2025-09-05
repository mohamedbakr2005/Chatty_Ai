abstract class HomeState {
  const HomeState();
}

class HomeInitial extends HomeState {
  const HomeInitial();
}

class HomeLoading extends HomeState {
  const HomeLoading();
}

class HomeWelcome extends HomeState {
  const HomeWelcome();
}

class HomeChat extends HomeState {
  const HomeChat();
}

class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);
}
