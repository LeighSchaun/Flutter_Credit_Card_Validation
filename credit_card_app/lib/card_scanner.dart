import 'package:flutter/material.dart';
import 'package:credit_card_scanner/credit_card_scanner.dart';

class MyCardScanner extends StatefulWidget {
  final Function(CardDetails) onCardScanned;

  const MyCardScanner({Key? key, required this.onCardScanned})
      : super(key: key);

  @override
  State<MyCardScanner> createState() => _MyCardScannerState();
}

class _MyCardScannerState extends State<MyCardScanner> {
  CardDetails? _cardDetails;

  // Function to initiate the card scanning process
  Future<void> scanCard() async {
    final CardDetails? cardDetails = await CardScanner.scanCard();
    if (!mounted || cardDetails == null) return;
    setState(() {
      _cardDetails = cardDetails;
      widget.onCardScanned(
          cardDetails); // Callback to notify parent about the scanned card details
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Credit Card Scanner'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Show a button to trigger the card scanning process
            if (_cardDetails == null)
              ElevatedButton(
                onPressed: () => scanCard(),
                child: const Text('Scan Card'),
              ),
            // If the card has been scanned, display its details
            if (_cardDetails != null)
              Column(
                children: [
                  // Display a placeholder for Card Holder Name and CVV to be entered manually
                  Text(
                      'Card Holder: Please enter manually for verification purposes'),
                  Text('Card Number: ${_cardDetails!.cardNumber}'),
                  Text('Expiry Date: ${_cardDetails!.expiryDate ?? 'N/A'}'),
                  Text('CVV: Please enter manually for verification purposes'),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
