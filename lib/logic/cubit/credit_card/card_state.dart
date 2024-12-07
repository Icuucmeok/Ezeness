part of 'card_bloc.dart';

// card_state.dart
abstract class CardState {}

class CardInitialState extends CardState {
}

class CardLoadedState extends CardState {
  final List<CardModel> cards;
  final int selectedIndex;

  CardLoadedState({
    required this.cards,
    required this.selectedIndex,
  });
}

class CardErrorState extends CardState {
  final String message;

  CardErrorState(this.message);
}
