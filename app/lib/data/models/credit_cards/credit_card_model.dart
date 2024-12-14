List<CardModel> cardList = [
  CardModel(
    cardType: 'Visa',
    lastDigits: '1234',
    cardHolderName: 'Card Holder Name',
    expiryDate: '01/2025',
  ),
  CardModel(
    cardType: 'Visa',
    lastDigits: '5678',
    cardHolderName: 'Card Holder Name',
    expiryDate: '03/2026',
  ),
];

int selectedCardIndex = 0;

class CardModel {
  final String cardType;
  final String lastDigits;
  final String cardHolderName;
  final String expiryDate;

  CardModel({
    required this.cardType,
    required this.lastDigits,
    required this.cardHolderName,
    required this.expiryDate,
  });
}
