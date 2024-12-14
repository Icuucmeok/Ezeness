import 'package:bloc/bloc.dart';

import '../../../data/models/credit_cards/credit_card_model.dart';

part 'card_event.dart';
part 'card_state.dart';

class CardBloc extends Bloc<CardEvent, CardState> {
  final List<CardModel> _cardList = [];
  int _selectedCardIndex = 0;

  CardBloc() : super(CardInitialState()) {
    on<LoadCardsEvent>(_onLoadCards);
    on<AddCardEvent>(_onAddCard);
    on<SelectCardEvent>(_onSelectCard);
  }

  void _onLoadCards(LoadCardsEvent event, Emitter<CardState> emit) {
    // Ensure the card list is initialized
    emit(CardLoadedState(
        cards: List.unmodifiable(_cardList),
        selectedIndex: _selectedCardIndex));
  }

  void _onAddCard(AddCardEvent event, Emitter<CardState> emit) {
    // Add new card and emit updated state
    _cardList.add(event.card);

    // Emit updated card list with a new immutable reference
    emit(CardLoadedState(
        cards: List.unmodifiable(_cardList),
        selectedIndex: _selectedCardIndex));
  }

  void _onSelectCard(SelectCardEvent event, Emitter<CardState> emit) {
    // Update selected card index
    _selectedCardIndex = event.selectedIndex;

    // Emit updated selected index state
    emit(CardLoadedState(
        cards: List.unmodifiable(_cardList),
        selectedIndex: _selectedCardIndex));
  }
}
