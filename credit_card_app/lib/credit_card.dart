import 'dart:convert';

class CreditCard {
  final String cardHolderName;
  final String cardNumber;
  final String cardType;
  final String cvv;
  final String issuingCountry;
  final String expiryDate;
  final DateTime captureDate; // New field for capture date

  // CreditCard constructor
  CreditCard({
    required this.cardHolderName,
    required this.cardNumber,
    required this.cardType,
    required this.cvv,
    required this.issuingCountry,
    required this.expiryDate,
    required this.captureDate,
  });

  // Convert CreditCard object to JSON format
  Map<String, dynamic> toJson() {
    return {
      'cardHolderName': cardHolderName,
      'cardNumber': cardNumber,
      'cardType': cardType,
      'cvv': cvv,
      'issuingCountry': issuingCountry,
      'expiryDate': expiryDate,
      'captureDate':
          captureDate.toIso8601String(), // Convert DateTime to String
    };
  }

  // Factory method to create CreditCard object from JSON data
  factory CreditCard.fromJson(Map<String, dynamic> json) {
    return CreditCard(
      cardHolderName: json['cardHolderName'],
      cardNumber: json['cardNumber'],
      cardType: json['cardType'],
      cvv: json['cvv'],
      issuingCountry: json['issuingCountry'],
      expiryDate: json['expiryDate'],
      captureDate:
          DateTime.parse(json['captureDate']), // Parse DateTime from String
    );
  }
}
