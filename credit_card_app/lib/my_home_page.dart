import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'credit_card.dart';
import 'credit_card_list.dart';
import 'dart:convert';
import 'package:credit_card_scanner/credit_card_scanner.dart';
import 'card_scanner.dart'; // Import the card scanning implementation
import 'package:flutter/services.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Controllers for the input fields
  final TextEditingController cardHolderNameController =
      TextEditingController();
  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController cvvController = TextEditingController();
  final TextEditingController expiryDateController = TextEditingController();
  final TextEditingController issuingCountryController =
      TextEditingController();

  // List of countries that are banned for issuing cards
  final List<String> bannedCountries = [
    'Russia',
    'Burma (Myanmar)',
    'Iran',
    'Sudan',
    'Syria',
    'North Korea',
  ];

  // Initialize the credit card list to store captured cards
  CreditCardList creditCardList = CreditCardList();

  // Function to show a SnackBar with a message
  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 3),
      ),
    );
  }

  // Function to validate the credit card and add it to the list if valid
  void validateCard() {
    String cardHolderName = cardHolderNameController.text;
    String cardNumber = cardNumberController.text;
    String cardType = inferCardType(cardNumber);
    String cvv = cvvController.text;
    String expiryDate = expiryDateController.text;
    String issuingCountry = issuingCountryController.text;

    if (!isCountryBanned(issuingCountry)) {
      if (!creditCardList.isCardCaptured(cardNumber)) {
        CreditCard card = CreditCard(
          cardHolderName: cardHolderName,
          cardNumber: cardNumber,
          cardType: cardType,
          cvv: cvv,
          issuingCountry: issuingCountry,
          expiryDate: expiryDate,
          captureDate: DateTime.now(), // Capture the current date
        );

        creditCardList.addCard(card);

        cardHolderNameController.clear();
        cardNumberController.clear();
        cvvController.clear();
        expiryDateController.clear();
        issuingCountryController.clear();

        saveCapturedCardsToStorage();
      } else {
        showSnackBar('Card is already captured!');
      }
    } else {
      showSnackBar('Issuing country is banned!');
    }

    setState(() {});
  }

  // Function to check if a country is banned
  bool isCountryBanned(String issuingCountry) {
    return bannedCountries.contains(issuingCountry);
  }

  // Function to infer the card type from the card number
  String inferCardType(String cardNumber) {
    if (cardNumber.startsWith('4')) {
      return 'Visa';
    } else if (cardNumber.startsWith('5')) {
      return 'MasterCard';
    } else if (cardNumber.startsWith('3')) {
      return 'American Express';
    } else {
      return 'Unknown';
    }
  }

  // Load captured cards from local storage when the app starts
  @override
  void initState() {
    super.initState();
    loadCapturedCardsFromStorage();
  }

  // Function to save captured cards to local storage
  Future<void> saveCapturedCardsToStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> capturedCardsData = creditCardList.capturedCards
        .map((card) => jsonEncode(card.toJson()))
        .toList();
    await prefs.setStringList('capturedCards', capturedCardsData);
  }

  // Function to load captured cards from local storage
  Future<void> loadCapturedCardsFromStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? capturedCardsData = prefs.getStringList('capturedCards');
    if (capturedCardsData != null) {
      List<CreditCard> loadedCapturedCards = capturedCardsData
          .map((data) =>
              CreditCard.fromJson(Map<String, dynamic>.from(jsonDecode(data))))
          .toList();
      setState(() {
        creditCardList.capturedCards = loadedCapturedCards;
      });
    }
  }

  // Callback function when a card is scanned using the card scanner
  void _onCardScanned(CardDetails cardDetails) {
    setState(() {
      cardHolderNameController.text = cardDetails.cardHolderName ?? '';
      cardNumberController.text = cardDetails.cardNumber;
      expiryDateController.text = cardDetails.expiryDate ?? '';
      issuingCountryController.text = '';
    });
  }

  // Function to handle the "Scan Credit Card" button press
  void _handleScanButtonPressed() async {
    try {
      var result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MyCardScanner(onCardScanned: _onCardScanned),
        ),
      );
      if (result != null) {
        showSnackBar('Card scanned successfully!');
      }
    } catch (e) {
      print('Error scanning credit card: $e');
    }
  }

  // Function to clear all captured cards
  void _clearCapturedCards() {
    setState(() {
      creditCardList.clearCards();
      saveCapturedCardsToStorage();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Credit Card Validation'), // Title of the page
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Input field for Card Holder Name
                Text(
                  'Card Holder Name:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextFormField(
                    controller: cardHolderNameController,
                    decoration: InputDecoration(
                      hintText: 'Enter card holder name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 24),
                // Input field for Card Number
                Text(
                  'Card Number:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextFormField(
                    controller: cardNumberController,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(19),
                    ],
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Enter your card number',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 24),
                // Input fields for Expiry Date and CVV
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Expiry Date:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: TextFormField(
                              controller: expiryDateController,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(4),
                              ],
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: '(MM/YY)',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'CVV:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: TextFormField(
                              controller: cvvController,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(3),
                              ],
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: 'CVV',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24),
                // Input field for Issuing Country
                Text(
                  'Issuing Country:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextFormField(
                    controller: issuingCountryController,
                    decoration: InputDecoration(
                      hintText: 'Enter your issuing country',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 24),
                // Scan Credit Card button
                Center(
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _handleScanButtonPressed,
                      child: Text('Scan Credit Card'),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                // Validate button
                Center(
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: validateCard,
                      child: Text('Validate'),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                // Clear Captured Cards button
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _clearCapturedCards,
                        child: Text('Clear Captured Cards'),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                // List of Captured Credit Cards
                Text(
                  'Captured Credit Cards:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                ListView.separated(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: creditCardList.capturedCards.length,
                  separatorBuilder: (context, index) => Divider(),
                  itemBuilder: (context, index) {
                    CreditCard card = creditCardList.capturedCards[index];
                    return ListTile(
                      title: Text('Card Number: ${card.cardNumber}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Card Type: ${card.cardType}'),
                          Text('Card Holder: ${card.cardHolderName}'),
                          Text('Captured Date: ${card.captureDate}'),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
