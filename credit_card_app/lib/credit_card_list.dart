import 'credit_card.dart';

class CreditCardList {
  List<CreditCard> _capturedCards = [];

  // Get the list of captured credit cards
  List<CreditCard> get capturedCards => _capturedCards;

  // Set the list of captured credit cards
  set capturedCards(List<CreditCard> value) {
    _capturedCards = value;
  }

  // Check if a credit card with the specified card number is already captured
  bool isCardCaptured(String cardNumber) {
    return _capturedCards.any((card) => card.cardNumber == cardNumber);
  }

  // Add a credit card to the list of captured cards if it's not already captured
  void addCard(CreditCard card) {
    if (!isCardCaptured(card.cardNumber)) {
      _capturedCards.add(card);
    }
  }

  // Clear the list of captured credit cards
  void clearCards() {
    _capturedCards.clear();
  }
}
