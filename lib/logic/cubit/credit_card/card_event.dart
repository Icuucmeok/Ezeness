part of 'card_bloc.dart';

// card_event.dart
abstract class CardEvent {}

class LoadCardsEvent extends CardEvent {}

class AddCardEvent extends CardEvent {
  final CardModel card;

  AddCardEvent(this.card);
}

class SelectCardEvent extends CardEvent {
  final int selectedIndex;

  SelectCardEvent(this.selectedIndex);
}
